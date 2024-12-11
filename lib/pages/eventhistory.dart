import 'package:bloodlife/pages/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Eventhistory extends StatefulWidget {
  const Eventhistory({Key? key}) : super(key: key);

  @override
  State<Eventhistory> createState() => _EventhistoryState();
}

class _EventhistoryState extends State<Eventhistory> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;
  Map<String, bool> isDescriptionVisible = {};

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

  String _getMonth(String month) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthIndex = int.tryParse(month) ?? 0;
    return monthIndex > 0 && monthIndex <= 12 ? months[monthIndex - 1] : 'NA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Events",style: TextStyle(fontFamily: "Poppins-Medium"),),
        centerTitle: true,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('event')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No events created by you"));
          }
          final events = snapshot.data!.docs;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return buildEventCard(events[index]);
            },
          );
        },
      ),
    );
  }

  Widget buildEventCard(DocumentSnapshot event) {
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
        child: GestureDetector(
          onTap: () {
            setState(() {
              isDescriptionVisible[eventId] = !(isDescriptionVisible[eventId] ?? false);
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            fontFamily: "Poppins-Medium",
                            fontSize: 20,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          _getMonth(event['date']?.split('-')[1] ?? '0'),
                          style: const TextStyle(
                            fontFamily: "Poppins-Light",
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['name'] ?? 'Event Name',
                      style: const TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'By ${event['organizer'] ?? 'Unknown'}',
                      style: const TextStyle(
                        fontFamily: "Poppins-Light",
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          event['time'] ?? 'Time',
                          style: const TextStyle(
                            fontFamily: "Poppins-Light",
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Icon(Icons.location_on, size: 16.0),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            event['venue'] ?? 'Venue',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Poppins-Light",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Show description only if isDescriptionVisible[eventId] is true
                    if (isDescriptionVisible[eventId] ?? false)
                      Text(
                        event['description'] ?? 'No description provided',
                        style: const TextStyle(
                          fontFamily: "Poppins-Light",
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
