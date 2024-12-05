import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class CreateBloodRequestScreen extends StatefulWidget {
  @override
  _CreateBloodRequestScreenState createState() =>
      _CreateBloodRequestScreenState();
}

class _CreateBloodRequestScreenState extends State<CreateBloodRequestScreen> {
  final _formKey = GlobalKey<FormState>(); // Global key for form validation
  bool isUrgent = false;
  String? fileName;

  // Controllers to access form field data
  TextEditingController patientNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController neededDateController = TextEditingController();

  String? selectedBloodType;
  String _date = ''; // Variable to hold the selected date
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Function to open file picker and get file
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name; // Set the file name
      });
    }
  }

  // Function to handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Await Firestore operation
        await _firestore.collection('bloodRequests').add({
          'patientName': patientNameController.text,
          'location': locationController.text,
          'contact': contactController.text,
          'bloodType': selectedBloodType,
          'neededDate': neededDateController.text,
          'urgent': isUrgent,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blood Request Submitted Successfully')),
        );

        // Clear the form after successful submission
        patientNameController.clear();
        locationController.clear();
        contactController.clear();
        neededDateController.clear();
        setState(() {
          selectedBloodType = null;
          isUrgent = false;
          fileName = null;
        });

      } catch (e) {
        // Handle errors in a user-friendly way
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request: $e')),
        );
      }
    }
  }


  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _date = "${pickedDate.toLocal()}".split(' ')[0]; // Format the date to yyyy-mm-dd
        neededDateController.text = _date; // Set the date to TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Create a Blood Request',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Name
                TextFormField(
                  controller: patientNameController,
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Patient Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Contact Number
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact Number is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Blood Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Blood Type',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedBloodType,
                  items: [
                    DropdownMenuItem(value: 'A+', child: Text('A+')),
                    DropdownMenuItem(value: 'A-', child: Text('A-')),
                    DropdownMenuItem(value: 'B+', child: Text('B+')),
                    DropdownMenuItem(value: 'B-', child: Text('B-')),
                    DropdownMenuItem(value: 'O+', child: Text('O+')),
                    DropdownMenuItem(value: 'O-', child: Text('O-')),
                    DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                    DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedBloodType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Blood Type is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Needed Date (GestureDetector)
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: neededDateController,
                      decoration: InputDecoration(
                        labelText: 'Needed Date',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      onSaved: (value) => _date = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Additional Information
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Enter additional information (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Upload Medical Documents (File Picker)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: pickFile,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey[200],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              fileName != null ? fileName! : 'Upload Medical Documents',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Urgent Need Checkbox
                Row(
                  children: [
                    Text(
                      'Urgent Need',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Checkbox(
                      value: isUrgent,
                      onChanged: (value) {
                        setState(() {
                          isUrgent = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF2A39), // Red color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Submit Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
