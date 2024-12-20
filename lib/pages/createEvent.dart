import 'package:bloodlife/splashscreen/notification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _isLoading = false;

  // Function to submit event data to Firestore
  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Add event details to Firestore
      await FirebaseFirestore.instance.collection('event').add({
        'name': _nameController.text.trim(),
        'venue': _venueController.text.trim(),
        'organizer': _organizerController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': _dateController.text.trim(),
        'time': _timeController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'userId': user!.uid,
        'status': 'Upcoming',
        'participants': [],
        'completed': false,
        'cancelled': false,
      });

      // Clear input fields after successful submission
      _nameController.clear();
      _venueController.clear();
      _organizerController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _timeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );

      Future.delayed(Duration(seconds: 5)).then((_) {
        NotificationService().showNotification(
          id: 1,
          title: "New Event Created",
          body:
              "Your event '${_nameController.text.trim()}' has been added successfully.",
          payload: "event_created",
        );
      });

      // Optional: Navigate back to the previous screen
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to select date using a date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Function to select time using a time picker
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create an Event',
          style: TextStyle(fontFamily: "Poppins-Medium"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Name Input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: "Poppins-Light"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Venue Input
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: "Poppins-Light"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter venue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Organizer Input
              TextFormField(
                controller: _organizerController,
                decoration: const InputDecoration(
                  labelText: 'Organizer\'s Name',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: "Poppins-Light"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter organizer\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: "Poppins-Light"),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Time Picker
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: "Poppins-Light"),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Event Description Input
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: "Poppins-Light"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Create Event Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Event',
                        style: TextStyle(
                            fontFamily: "Poppins-Medium", color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
