import 'package:flutter/material.dart';
import '../models/event.dart';
import '../pages/createEvent.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final List<Event> _allEvents = [
    Event(
      name: 'Blood Donation Drive by Red Cross',
      organizer: 'Red Cross Society',
      date: '2024-12-10',
      time: '9:00 AM - 3:00 PM',
      venue: 'Red Cross Blood Donation Center, Kathmandu',
      description: 'Join the Red Cross Blood Donation Drive and help save lives. Donors will receive a certificate and refreshments.',
    ),
    Event(
      name: 'Blood Donation Campaign: Save Lives',
      organizer: 'Nepal Blood Bank',
      date: '2024-12-12',
      time: '10:00 AM - 4:00 PM',
      venue: 'Nepal Blood Bank, Lalitpur',
      description: 'Donate blood and save lives. Each donation can save up to three lives. Refreshments and a small token of appreciation will be provided.',
    ),
    Event(
      name: 'University Blood Donation Drive',
      organizer: 'Kathmandu University Students Association',
      date: '2024-12-15',
      time: '9:00 AM - 1:00 PM',
      venue: 'Kathmandu University Campus, Dhulikhel',
      description: 'Students and staff of Kathmandu University come together for a blood donation drive to support local hospitals in need of blood.',
    ),
    Event(
      name: 'Blood Donation & Health Checkup',
      organizer: 'City Hospital, Kathmandu',
      date: '2024-12-18',
      time: '8:00 AM - 2:00 PM',
      venue: 'City Hospital, Kathmandu',
      description: 'A combined event for blood donation and free health checkup. Get a health check while saving lives by donating blood.',
    ),
    Event(
      name: 'Corporate Blood Donation Event',
      organizer: 'Tech Corp',
      date: '2024-12-22',
      time: '10:00 AM - 3:00 PM',
      venue: 'Tech Corp Office, Kathmandu',
      description: 'Tech Corp employees and the general public are invited to donate blood and contribute to a noble cause. Free snacks and a thank you gift for all donors.',
    ),
    Event(
      name: 'Blood Donation for Emergency Victims',
      organizer: 'Hospitals Association of Nepal',
      date: '2024-12-25',
      time: '9:00 AM - 5:00 PM',
      venue: 'Various Hospitals in Kathmandu Valley',
      description: 'Join us in this urgent blood donation campaign for victims of recent accidents and natural disasters. Your donation can save lives.',
    ),
  ];

  final List<Event> _myEvents = [
    Event(
      name: 'Blood Donation Drive by Red Cross',
      organizer: 'Red Cross Society',
      date: '2024-12-10',
      time: '9:00 AM - 3:00 PM',
      venue: 'Red Cross Blood Donation Center, Kathmandu',
      description: 'Join the Red Cross Blood Donation Drive and help save lives. Donors will receive a certificate and refreshments.',
    ),
    Event(
      name: 'University Blood Donation Drive',
      organizer: 'Kathmandu University Students Association',
      date: '2024-12-15',
      time: '9:00 AM - 1:00 PM',
      venue: 'Kathmandu University Campus, Dhulikhel',
      description: 'Students and staff of Kathmandu University come together for a blood donation drive to support local hospitals in need of blood.',
    ),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Events',
          style: TextStyle(
            fontFamily: "Poppins-Medium",
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xffEF2A39),
          tabs: const [
            Tab(text: 'All Events'),
            Tab(text: 'My Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(_allEvents, 'No events available.\nCreate a new event to get started.'),
          _buildEventsList(_myEvents, 'You have no event history.'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEventScreen(),
            ),
          );
          if (newEvent != null && newEvent is Event) {
            setState(() {
              _allEvents.add(newEvent);
              _myEvents.add(newEvent); // Optionally add to My Events
            });
          }
        },
        backgroundColor: const Color(0xffEF2A39),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventsList(List<Event> events, String emptyMessage) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildEventCard(event),
        );
      },
    );
  }

  Widget _buildEventCard(Event event) {
    final isMyEvent = _myEvents.contains(event);  // Check if the event is in "My Events" list

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Event Date
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
                          event.date.split('-')[2], // Day
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          _getMonth(event.date), // Month
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Event Name & Organizer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'By ${event.organizer}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Event Details (Time, Venue)
            Row(
              children: [
                const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Text(
                  event.time,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(width: 16.0),
                const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    event.venue,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Event Description
            Text(
              event.description,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 16.0),
            // Event Interaction Buttons (only visible for "All Events")
            if (!isMyEvent)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Interested" action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Interested'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Accept Event" action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Accept Event'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMonth(String date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthIndex = int.parse(date.split('-')[1]) - 1;
    return months[monthIndex];
  }
}
