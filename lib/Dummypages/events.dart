import 'package:bloodlife/pages/createEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events List"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No data available"));
          }
          final events = snapshot.data!.docs;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EventName: ${event['name'] ?? 'Not specified'}',
                        style: const TextStyle(
                            fontSize: 19.0, fontFamily: 'Poppins-Light'),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Venue: ${event['venue'] ?? 'Not specified'}',
                        style: const TextStyle(
                            fontSize: 16.0, fontFamily: 'Poppins-Light'),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Organizer: ${event['organizer'] ?? 'Not specified'}',
                        style: const TextStyle(
                            fontSize: 16.0, fontFamily: 'Poppins-Light'),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Date: ${event['date'] ?? 'Not specified'}',
                        style: const TextStyle(
                            fontSize: 16.0, fontFamily: 'Poppins-Light'),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Time: ${event['time'] ?? 'Not specified'}',
                        style: const TextStyle(
                            fontSize: 16.0, fontFamily: 'Poppins-Light'),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        event['description'] ?? 'No Description',
                        style: const TextStyle(
                            fontSize: 16.0, fontFamily: 'Poppins-Light'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateEventScreen(),
            ),
          );
        },
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffEF2A39), width: 2),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white),
          child: const Center(
            child: Text(
              "Add Event",
              style: TextStyle(
                  color: Color(0xffEF2A39), fontFamily: 'Poppins-Light'),
            ),
          ),
        ),
      ),
    );
  }
}
