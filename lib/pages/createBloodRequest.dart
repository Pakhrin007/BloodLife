import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreateBloodRequestScreen extends StatefulWidget {
  @override
  _CreateBloodRequestScreenState createState() => _CreateBloodRequestScreenState();
}

class _CreateBloodRequestScreenState extends State<CreateBloodRequestScreen> {
  bool isUrgent = false;  // To manage the state of the "Urgent Need" checkbox
  String? fileName;  // To store the name of the selected file

  // Function to open file picker and get file
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name; // Set the file name
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Name
              TextField(
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Location
              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Contact Number
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Blood Type Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(),
                ),
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
                onChanged: (value) {},
              ),
              SizedBox(height: 16),

              // Needed Date
              TextField(
                decoration: InputDecoration(
                  labelText: 'Needed Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SizedBox(height: 16),

              // Additional Information
              TextField(
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
                  onPressed: () {
                    // Handle submit action
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
    );
  }
}

void main() => runApp(MaterialApp(
  home: CreateBloodRequestScreen(),
));
