import 'package:bloodlife/pages/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;
  final Set<String> interestedEvents = {};
  final Map<String, bool> expandedEvents = {};

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
    final String status = event['status'] ?? 'active';
    bool isGoing = event['participants'].contains(user.uid);

    String date = event['date'] ?? 'NA';
    List<String> dateParts = date.split('-');
    String day = (dateParts.length > 2) ? dateParts[2] : 'NA';
    String month = (dateParts.length > 1) ? _getMonth(dateParts[1]) : 'NA';

    bool isExpanded = expandedEvents[eventId] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          expandedEvents[eventId] = !isExpanded;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                              fontFamily: "Poppins-Medium",
                            ),
                          ),
                          Text(
                            month,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                              fontFamily: "Poppins-Medium",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['name'] ?? 'Event Name',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins-Medium",
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          event['organizer'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                            fontFamily: "Poppins-Light",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Text(
                    event['time'] ?? 'Time',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: "Poppins-Light",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      event['venue'] ?? 'Venue',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontFamily: "Poppins-Light",
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ConstrainedBox(
                  constraints: isExpanded
                      ? const BoxConstraints()
                      : const BoxConstraints(maxHeight: 0),
                  child: Text(
                    event['description'] ?? 'No description provided',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontFamily: "Poppins-Light",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (status == 'cancelled')
                const Center(
                  child: Text(
                    "This event has been cancelled.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFamily: "Poppins-Medium",
                    ),
                  ),
                )
              else if (status == 'completed')
                const Center(
                  child: Text(
                    "This event has ended.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontFamily: "Poppins-Medium",
                    ),
                  ),
                )
              else ...[
                  if (canManage) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: _buildButton('Complete', Colors.white, const Color(0xFFF44336), true, event),
                    ),
                    _buildButton('Cancel', const Color(0xFFF44336), Colors.white, true, event),
                  ],
                  if (!canManage)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isGoing) {
                              interestedEvents.remove(eventId);
                            } else {
                              interestedEvents.add(eventId);
                            }
                          });
                          _updateInterested(eventId, isGoing);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isGoing ? Colors.white : const Color(0xFFEF2A39),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(
                          isGoing ? 'Going' : 'Interested',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isGoing ? const Color(0xFFEF2A39) : Colors.white,
                            fontFamily: "Poppins-Medium",
                          ),
                        ),
                      ),
                    ),
                ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color textColor, Color backgroundColor, bool isActive, DocumentSnapshot event) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive
            ? () async {
          bool? confirm = await _showConfirmationDialog(context, label);
          if (confirm == true) {
            _updateEventStatus(event.id, label);
          }
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: "Poppins-Medium",
          ),
        ),
      ),
    );
  }

  Future<void> _updateEventStatus(String eventId, String action) async {
    try {
      final eventRef = FirebaseFirestore.instance.collection('event').doc(eventId);
      if (action == 'Complete') {
        await eventRef.update({'status': 'completed'});
      } else if (action == 'Cancel') {
        await eventRef.update({'status': 'cancelled'});
      }
    } catch (e) {
      print('Failed to update event status: $e');
    }
  }

  Future<void> _updateInterested(String eventId, bool isGoing) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      final userName = userDoc.data()?['FullName'] ?? 'Unknown User';

      final eventRef = FirebaseFirestore.instance.collection('event').doc(eventId);
      final eventDoc = await eventRef.get();
      List<String> participants = List<String>.from(eventDoc.data()?['participants'] ?? []);

      if (isGoing) {
        participants.remove(user.uid); // Remove user's ID if they are going
      } else {
        participants.add(user.uid); // Add user's ID if they are interested
      }

      await eventRef.update({'participants': participants});

      final goingEvents = List<String>.from(userDoc.data()?['goingEvents'] ?? []);
      if (isGoing) {
        goingEvents.remove(eventId);
      } else {
        goingEvents.add(eventId);
      }
      await userRef.update({'goingEvents': goingEvents});

    } catch (e) {
      print('Failed to update user participation and event participants: $e');
    }
  }

  String _getMonth(String month) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthIndex = int.tryParse(month) ?? 0;
    return monthIndex > 0 && monthIndex <= 12 ? months[monthIndex - 1] : 'NA';
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, String action) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF2A39), // Custom title color
              fontFamily: "Poppins-Medium", // Font style
            ),
          ),
          content: Text(
            'Do you want to $action?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87, // Custom content color
              fontFamily: "Poppins-Light", // Font style
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog with 'false'
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF2A39), // Custom cancel button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: const BorderSide(color: Color(0xFFEF2A39)), // Border for cancel button
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins-Medium", // Font style
                ),
              ),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog with 'true'
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEF2A39), // Custom confirm button color
                foregroundColor: Colors.white, // Button text color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins-Medium", // Font style
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Events",
            style: TextStyle(
              fontFamily: "Poppins-Medium",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "All Events"),
              Tab(text: "My Events"),
            ],
            labelStyle: TextStyle(
              fontFamily: "Poppins-Medium",
            ),
          ),
        ),
        body: userData == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('event').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No events available"));
                }
                final events = snapshot.data!.docs;
                events.sort((a, b) {
                  DateTime dateA = DateTime.parse(a['date']);
                  DateTime dateB = DateTime.parse(b['date']);
                  return dateA.compareTo(dateB);
                });
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return buildEventCard(events[index], false);
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
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
                events.sort((a, b) {
                  DateTime dateA = DateTime.parse(a['date']);
                  DateTime dateB = DateTime.parse(b['date']);
                  return dateA.compareTo(dateB);
                });
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
              MaterialPageRoute(builder: (context) => const CreateEventScreen()),
            );
          },
          backgroundColor: const Color(0xFFEF2A39),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
