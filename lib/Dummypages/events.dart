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
          _buildEventsList(_allEvents, 'No events available.\nCreate a new event to get started.', false),
          _buildEventsList(_myEvents, 'You have no event history.', true),
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

  Widget _buildEventsList(List<Event> events, String emptyMessage, bool isMyEvents) {
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
          child: _ExpandableEventCard(event: event, isMyEvent: isMyEvents),
        );
      },
    );
  }
}

class _ExpandableEventCard extends StatefulWidget {
  final Event event;
  final bool isMyEvent; // Flag to differentiate between 'All Events' and 'My Events'

  const _ExpandableEventCard({Key? key, required this.event, required this.isMyEvent}) : super(key: key);

  @override
  __ExpandableEventCardState createState() => __ExpandableEventCardState();
}

class __ExpandableEventCardState extends State<_ExpandableEventCard> {
  bool _isDescriptionExpanded = false; // Toggle for description visibility
  bool _isGoing = false; // State for the button (Interested/Going)
  bool _isCompleted = false; // State to track Completed button
  bool _isCancelled = false; // State to track Cancelled button

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDescriptionExpanded = !_isDescriptionExpanded; // Toggle description
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
                            widget.event.date.split('-')[2], // Day
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins-Medium",
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            _getMonth(widget.event.date), // Month
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins-Medium",
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
                          widget.event.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins-Medium",
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.event.organizer,
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
              // Event Time
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Text(
                    widget.event.time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14, fontFamily: "Poppins-Light"),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Event Location
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      widget.event.venue,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14, fontFamily: "Poppins-Light"),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Description - shown only when expanded
              if (_isDescriptionExpanded)
                Text(
                  widget.event.description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14, fontFamily: "Poppins-Light"),
                ),
              const SizedBox(height: 16.0),
              // Button Section for My Events
              if (widget.isMyEvent)
                Row(
                  children: [
                    // Show Completed Button if event is completed
                    if (_isCompleted)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: null, // Disable the button
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                  color: Color(0xFFEF2A39),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            child: const Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF2A39),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Show Cancelled Button if event is cancelled
                    if (_isCancelled)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: null, // Disable the button
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                  color: Color(0xFFEF2A39),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            child: const Text(
                              'Cancelled',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF2A39),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Show Complete and Cancel buttons when the event is not yet completed or cancelled
                    if (!_isCompleted && !_isCancelled)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool? confirm = await _showConfirmationDialog(context, 'Complete the Event');
                              if (confirm == true) {
                                setState(() {
                                  _isCompleted = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF2A39),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            child: const Text(
                              'Complete',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Cancel button
                    if (!_isCancelled && !_isCompleted)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool? confirm = await _showConfirmationDialog(context, 'Cancel the Event');
                              if (confirm == true) {
                                setState(() {
                                  _isCancelled = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                  color: Color(0xFFEF2A39),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF2A39),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              // Interested/Going Button for non-my-events
              if (!widget.isMyEvent && !_isCompleted && !_isCancelled)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isGoing = !_isGoing; // Toggle button text and style
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isGoing ? Colors.white : const Color(0xFFEF2A39),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: _isGoing ? const Color(0xFFEF2A39) : Colors.transparent,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      _isGoing ? 'Going' : 'Interested',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Medium",
                        color: _isGoing ? const Color(0xFFEF2A39) : Colors.white,
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

  String _getMonth(String date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthIndex = int.parse(date.split('-')[1]) - 1;
    return months[monthIndex];
  }

  // Confirmation Dialog before completing or canceling
  Future<bool?> _showConfirmationDialog(BuildContext context, String action) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Custom background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for the dialog
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
                Navigator.of(context).pop(false); // Close the dialog with 'false'
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFEF2A39), // Custom cancel button color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(color: Color(0xFFEF2A39)), // Border for cancel button
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
                backgroundColor: Color(0xFFEF2A39), // Custom confirm button color
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
