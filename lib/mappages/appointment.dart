import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
  late String _additionalInfo;
  File? selectedMedicalFile;
  String? cloudinaryFileUrl;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _uploadedFileUrl;

  final cloudinary = CloudinaryPublic(
    'dykgt0uth', // Replace with your Cloudinary cloud name
    'bloodlife', // Replace with your upload preset
    cache: false,
  );

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> pickMedicalDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        setState(() {
          selectedMedicalFile = file;
        });

        String? uploadedUrl = await uploadToCloudinary(file);
        if (uploadedUrl != null) {
          setState(() {
            cloudinaryFileUrl = uploadedUrl;
            _uploadedFileUrl = uploadedUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Document uploaded successfully')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed: $e')),
      );
    }
  }

  // Initialize user data by fetching from Firestore
  void _initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore based on user UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        // Populate the fields with user data from Firestore
        setState(() {
          _nameController.text = userData['FullName'] ?? '';
          _contactController.text = userData['PhoneNumber'] ?? '';
          _bloodType = userData['BloodType'] ?? 'O+'; // Set default blood type if not found
        });
      } else {
        // Handle the case where user data is not found in Firestore
        setState(() {
          _nameController.text = '';
          _contactController.text = '';
          _bloodType = 'O+'; // Default blood type
        });
      }
    }
  }

  Future<String?> uploadToCloudinary(File file) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: 'appointments',
          resourceType: CloudinaryResourceType.Auto,
        ),
      );
      print("Uploaded file URL: ${response.secureUrl}");
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint('Cloudinary error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cloudinary upload failed: ${e.message}')),
      );
      return null;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      try {
        final user = FirebaseAuth.instance.currentUser!;
        final QuerySnapshot recentAppointments = await FirebaseFirestore
            .instance
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('appointmentDate', descending: true)
            .limit(1)
            .get();

        if (recentAppointments.docs.isNotEmpty) {
          final recentAppointment = recentAppointments.docs.first;
          final DateTime lastAppointmentDate =
              DateTime.parse(recentAppointment['appointmentDate']);

          final DateTime allowedBookingDate =
              lastAppointmentDate.add(const Duration(days: 85));

          if (DateTime.now().isBefore(allowedBookingDate)) {
            Get.snackbar("Error", "You cannot Appoint another date");
            return;
          }
        }

        await FirebaseFirestore.instance.collection('appointments').add({
          'donorName': _donorName,
          'contactNumber': _contactNumber,
          'bloodType': _bloodType,
          'appointmentDate': _appointmentDate.toIso8601String(),
          'additionalInfo': _additionalInfo,
          'hospitalName': widget.hospitalName,
          'hospitalAddress': widget.hospitalAddress,
          'fileUrl': _uploadedFileUrl,
          'userId': user.uid,
        });

        Get.snackbar("sucessfully", "Appointment sucessfull");
      } catch (e) {
        Get.snackbar("Already Appointed", "you cannot Appoint");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Form',style: TextStyle(fontFamily: "Poppins-Medium"),),
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
                decoration: InputDecoration(
                  labelText: "Hospital Name",
                  labelStyle: TextStyle(fontFamily: 'Poppins-Light'),
                ),
                readOnly: true,
              ),
              TextFormField(
                initialValue: widget.hospitalAddress,
                decoration: InputDecoration(
                  labelText: "Hospital Address",
                  labelStyle: TextStyle(fontFamily: 'Poppins-Light'),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Donor's Name",
                  labelStyle: TextStyle(fontFamily: 'Poppins-Light'),
                ),
                style: TextStyle(fontFamily: 'Poppins-Medium'),  // Bold text
                validator: (value) =>
                value!.isEmpty ? "Please enter your name" : null,
                onSaved: (value) {
                  _donorName = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  labelStyle: TextStyle(fontFamily: 'Poppins-Light'),
                ),
                style: TextStyle(fontFamily: 'Poppins-Medium'), // Bold text
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? "Please enter your contact number" : null,
                onSaved: (value) {
                  _contactNumber = value!;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Blood Type',
                  labelStyle: TextStyle(fontFamily: 'Poppins-Light'),
                ),
                value: _bloodType, // Set the initial blood type value
                items: [
                  'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
                ].map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                )).toList(),
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
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Appointment Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  labelStyle: TextStyle(fontFamily: 'Poppins-Light'),
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
                decoration: InputDecoration(
                    labelText: 'Enter additional information (optional)',
                    labelStyle: TextStyle(fontFamily: 'Poppins-Light')),
                onSaved: (value) {
                  _additionalInfo = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: pickMedicalDocument,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  _uploadedFileUrl == null
                      ? 'Upload Medical Documents'
                      : 'File Uploaded',
                  style: TextStyle(fontFamily: 'Poppins-Medium'), // Bold text
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Poppins-Medium'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
