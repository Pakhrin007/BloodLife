import 'package:bloodlife/pages/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:your_app_name/pages/create_event.dart'; // Adjust import path as needed

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;

  // Set to track events marked as interested
  final Set<String> interestedEvents = {};

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  Widget buildEventCard(DocumentSnapshot event, bool canManage) {
    final eventId = event.id;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date section
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        event['date']?.split('-')[2] ?? 'NA',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        event['date']?.split('-')[1] ?? 'NA',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            // Event details section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['name'] ?? 'Event Name',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'By ${event['organizer'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(event['time'] ?? 'Time'),
                      const SizedBox(width: 16.0),
                      const Icon(Icons.location_on, size: 16.0),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          event['venue'] ?? 'Venue',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event['description'] ?? 'No description provided',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10.0),
                  // Interested Button or Delete Button
                  Row(
                    children: [
                      // Interested Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (interestedEvents.contains(eventId)) {
                              interestedEvents.remove(eventId);
                            } else {
                              interestedEvents.add(eventId);
                            }
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                            color: interestedEvents.contains(eventId)
                                ? Colors.green
                                : Colors.red.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              interestedEvents.contains(eventId)
                                  ? "Interested"
                                  : "Interested?",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Delete Button for My Events
                      if (canManage) ...[
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('events')
                                  .doc(eventId)
                                  .delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Event deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete event: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Events"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "All Events"),
              Tab(text: "My Events"),
            ],
          ),
        ),
        body: userData == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // All Events Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No events available"));
                      }
                      final events = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return buildEventCard(events[index], false);
                        },
                      );
                    },
                  ),

                  // My Events Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('userId', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text("No events created by you"));
                      }
                      final events = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return buildEventCard(events[index], true);
                        },
                      );
                    },
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateEventScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Confirmation Dialog before completing or canceling
  Future<bool?> _showConfirmationDialog(
      BuildContext context, String action) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Custom background color
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Rounded corners for the dialog
          ),
          title: Text(
            'Are you sure?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF2A39), // Custom title color
            ),
          ),
          content: Text(
            'Do you want to $action?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87, // Custom content color
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog with 'false'
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Color(0xFFEF2A39), // Custom cancel button color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(
                    color: Color(0xFFEF2A39)), // Border for cancel button
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog with 'true'
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    Color(0xFFEF2A39), // Custom confirm button color
                foregroundColor: Colors.white, // Button text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
