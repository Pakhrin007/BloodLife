import 'package:flutter/material.dart';

class BloodDonationForm extends StatefulWidget {
  final String hospitalName; // Name of the selected hospital
  final String hospitalAddress; // Address of the selected hospital

  const BloodDonationForm({
    super.key,
    required this.hospitalName,
    required this.hospitalAddress,
  });

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

  final TextEditingController _dateController = TextEditingController(); // Controller for the date field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment for Blood Donation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This will pop the current screen and go back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Hospital Name and Address Section
              TextFormField(
                initialValue: widget.hospitalName, // Display the selected hospital's name
                decoration: const InputDecoration(labelText: "Hospital Name"),
                readOnly: true,
              ),
              TextFormField(
                initialValue: widget.hospitalAddress, // Display the selected hospital's address
                decoration: const InputDecoration(labelText: "Hospital Address"),
                readOnly: true,
              ),

              // Existing form fields for donor info, contact, blood type, etc.
              TextFormField(
                decoration: const InputDecoration(labelText: "Donor's Name"),
                onSaved: (value) {
                  _donorName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  _contactNumber = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Blood Type'),
                items: [
                  'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
                ].map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _bloodType = value!;
                  });
                },
              ),
              TextFormField(
                controller: _dateController, // Use the controller to update the text field
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
                      _dateController.text = "${_appointmentDate.toLocal()}".split(' ')[0]; // Update the controller with the selected date
                    });
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Enter additional information (optional)'),
                onSaved: (value) {
                  _additionalInfo = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement file upload functionality here
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Medical Documents'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Implement form submission functionality here
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Appoint Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
