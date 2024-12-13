import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BloodDonationForm extends StatefulWidget {
  final String hospitalName;
  final String hospitalAddress;

  const BloodDonationForm({
    Key? key,
    required this.hospitalName,
    required this.hospitalAddress,
  }) : super(key: key);

  @override
  _BloodDonationFormState createState() => _BloodDonationFormState();
}

class _BloodDonationFormState extends State<BloodDonationForm> {
  final _formKey = GlobalKey<FormState>();
  late String _donorName;
  late String _contactNumber;
  late String _bloodType;
  late DateTime _appointmentDate;
  late DateTime _dob;
  String? _additionalInfo;
  late String _weight;

  bool isBookingAllowed = true;
  String remainingTime = '';

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();  // Controller for DOB
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();  // Controller for weight

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _bloodType = 'O+';
  }

  void _initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = userData['FullName'] ?? '';
          _contactController.text = userData['PhoneNumber'] ?? '';
          _bloodType = userData['BloodType'] ?? 'O+';
          if (userData['DateOfBirth'] != null) {
            _dob = DateTime.parse(userData['DateOfBirth']);
            _dobController.text = "${_dob.toLocal()}".split(' ')[0];  // Format date
          }
          if (userData['Weight'] != null) {
            _weight = userData['Weight'].toString();
            _weightController.text = _weight;
          }
        });

        _checkIfBookingAllowed();
      }
    }
  }

  Future<void> _checkIfBookingAllowed() async {
    final user = FirebaseAuth.instance.currentUser!;
    await calculateNextDonationDate(user);

    if (!isBookingAllowed) {
      _startCountdownTimer();
    }
  }

  Future<void> calculateNextDonationDate(User user) async {
    try {
      DateTime? appointmentDate;
      DateTime? bloodRequestDate;

      final QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('appointmentDate', descending: true)
          .limit(1)
          .get();

      if (appointmentSnapshot.docs.isNotEmpty) {
        final appointmentDoc = appointmentSnapshot.docs.first;
        appointmentDate = DateTime.parse(appointmentDoc['appointmentDate']);
      }

      final QuerySnapshot bloodRequestSnapshot = await FirebaseFirestore
          .instance
          .collection('bloodRequests')
          .where('acceptedById', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (bloodRequestSnapshot.docs.isNotEmpty) {
        final bloodRequestDoc = bloodRequestSnapshot.docs.first;
        final neededDate = bloodRequestDoc['neededDate'];
        bloodRequestDate = DateTime.parse(neededDate);
      }

      // Determine the latest date between appointmentDate and bloodRequestDate
      DateTime? latestDate;
      if (appointmentDate != null && bloodRequestDate != null) {
        latestDate = appointmentDate.isAfter(bloodRequestDate)
            ? appointmentDate
            : bloodRequestDate;
      } else if (appointmentDate != null) {
        latestDate = appointmentDate;
      } else if (bloodRequestDate != null) {
        latestDate = bloodRequestDate;
      }

      // If a latest date was found, calculate the next donation date
      if (latestDate != null) {
        setState(() {
          final nextDonationDate = latestDate?.add(const Duration(days: 85));
          isBookingAllowed = DateTime.now().isAfter(nextDonationDate!);
          remainingTime = isBookingAllowed
              ? 'You can book now!'
              : '${nextDonationDate.difference(DateTime.now()).inDays} days, ${nextDonationDate.difference(DateTime.now()).inHours % 24} hours';
        });
      }
    } catch (e) {
      print('Failed to calculate next donation date: $e');
    }
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    if (remainingTime != 'You can book now!') {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          // Update the remaining time based on the next donation date
        });
      });
    }
  }

  // Function to check if the user meets the requirements (age >= 18 and weight >= 50)
  bool _isEligibleForDonation() {
    final age = DateTime.now().difference(_dob).inDays / 365.25;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (age < 18) {
      return false;
    }

    if (weight < 50) {
      return false;
    }

    return true;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      if (!_isEligibleForDonation()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Eligibility Check",style: TextStyle(fontFamily: "Poppins-Medium", color: Colors.red),),
            content: const Text(
                "You must be at least 18 years old and weigh at least 50 kg to donate blood.",style: TextStyle(fontFamily: "Poppins-Light"),),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK",style: TextStyle(fontFamily: "Poppins-Medium",color: Colors.red),),
              ),
            ],
          ),
        );
        return;
      }

      try {
        final user = FirebaseAuth.instance.currentUser!;

        if (!isBookingAllowed) {
          Get.snackbar("Error", "You cannot book another appointment yet.");
          return;
        }

        await FirebaseFirestore.instance.collection('appointments').add({
          'donorName': _donorName,
          'contactNumber': _contactNumber,
          'hospitalName': widget.hospitalName,
          'hospitalAddress': widget.hospitalAddress,
          'additionalInfo': _additionalInfo,
          'bloodType': _bloodType,
          'appointmentDate': _appointmentDate.toIso8601String(),
          'userId': user.uid,
          'dateOfBirth': _dob.toIso8601String(), // Save DOB
          'weight': _weight, // Save weight
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );
        Navigator.pop(context);
        Get.snackbar("Success", "Appointment booked successfully!");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking appointment: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: widget.hospitalName,
                decoration: const InputDecoration(labelText: "Hospital Name"),
                readOnly: true,
              ),
              TextFormField(
                initialValue: widget.hospitalAddress,
                decoration:
                const InputDecoration(labelText: "Hospital Address"),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Donor's Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter your name" : null,
                onSaved: (value) {
                  _donorName = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dob = pickedDate;
                      _dobController.text = "${_dob.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) =>
                value!.isEmpty ? "Please select your date of birth" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? "Please enter your contact number" : null,
                onSaved: (value) {
                  _contactNumber = value!;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Blood Type'),
                value: _bloodType,
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
                    .toList(),
                validator: (value) =>
                value == null ? "Please select a blood type" : null,
                onChanged: (value) {
                  setState(() {
                    _bloodType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Appointment Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _appointmentDate = pickedDate;
                      _dateController.text =
                      "${_appointmentDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) =>
                value!.isEmpty ? "Please select an appointment date" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Additional Information (optional)'),
                onSaved: (value) {
                  _additionalInfo = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              Text(
                isBookingAllowed
                    ? ''
                    : 'You can book your appointment in $remainingTime',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isBookingAllowed ? _submitForm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
