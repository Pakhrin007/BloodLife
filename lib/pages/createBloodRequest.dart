import 'dart:io';
import 'package:bloodlife/splashscreen/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';

class CreateBloodRequestScreen extends StatefulWidget {
  @override
  _CreateBloodRequestScreenState createState() =>
      _CreateBloodRequestScreenState();
}

class _CreateBloodRequestScreenState extends State<CreateBloodRequestScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController neededDateController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();

  // State Variables
  String? selectedBloodType;
  bool isUrgent = false;
  String _date = '';

  // Cloudinary Configuration
  final cloudinary = CloudinaryPublic(
    'dykgt0uth', // Replace with your Cloudinary cloud name
    'BloodLife', // Replace with your upload preset
    cache: false,
  );

  // Firestore Instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // File Picker Method


  // Date Picker Method
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _date = "${pickedDate.toLocal()}".split(' ')[0];
        neededDateController.text = _date;
      });
    }
  }

  // Form Submission Method
  Future<void> submitBloodRequest() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser!;
        await _firestore.collection('bloodRequests').add({
          'patientName': patientNameController.text,
          'location': locationController.text,
          'contactNumber': contactController.text,
          'bloodType': selectedBloodType,
          'neededDate': neededDateController.text,
          'additionalInfo': additionalInfoController.text,
          'isUrgent': isUrgent,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'acceptedBy': null,
          'isAccepted': false,
          'acceptedById': null,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blood Request Submitted Successfully')),
        );
        _resetForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: $e')),
        );
      }
    }
  }

  // Reset Form Method
  void _resetForm() {
    patientNameController.clear();
    locationController.clear();
    contactController.clear();
    neededDateController.clear();
    additionalInfoController.clear();

    setState(() {
      selectedBloodType = null;
      isUrgent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Blood Request',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins-Medium', // Bold font for title
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Patient Name
              TextFormField(
                controller: patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  labelStyle:
                      TextStyle(fontFamily: 'Poppins-Light'), // Regular font
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter patient name' : null,
              ),
              SizedBox(height: 16),

              // Location
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  labelStyle:
                      TextStyle(fontFamily: 'Poppins-Light'), // Regular font
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter location' : null,
              ),
              SizedBox(height: 16),

              // Contact Number
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  labelStyle:
                      TextStyle(fontFamily: 'Poppins-Light'), // Regular font
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter contact number' : null,
              ),
              SizedBox(height: 16),

              // Blood Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  labelStyle:
                      TextStyle(fontFamily: 'Poppins-Light'), // Regular font
                  border: OutlineInputBorder(),
                ),
                value: selectedBloodType,
                items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() {
                  selectedBloodType = value;
                }),
                validator: (value) =>
                    value == null ? 'Please select blood type' : null,
              ),
              const SizedBox(height: 16),

              // Needed Date
              TextFormField(
                controller: neededDateController,
                decoration: InputDecoration(
                  labelText: 'Needed Date',
                  labelStyle: const TextStyle(
                      fontFamily: 'Poppins-Light'), // Regular font
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'Please select needed date' : null,
              ),
              const SizedBox(height: 16),

              // Additional Information
              TextFormField(
                controller: additionalInfoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional Information (Optional)',
                  labelStyle:
                      TextStyle(fontFamily: 'Poppins-Light'), // Regular font
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

             

              // Urgent Checkbox
              Row(
                children: [
                  Checkbox(
                    value: isUrgent,
                    onChanged: (value) => setState(() {
                      isUrgent = value!;
                    }),
                  ),
                  const Text('Urgent Request',
                      style: TextStyle(
                          fontFamily: 'Poppins-Light')), // Regular font
                ],
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: submitBloodRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Submit Blood Request',
                  style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      color: Colors.black), // Bold font for button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
