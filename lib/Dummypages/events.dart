import 'package:flutter/material.dart';
import '../models/event.dart';
import '../pages/createEvent.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<Event> _events = [];
  List<bool> _isExpandedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _events.isEmpty
              ? Center(
            child: Text(
              'No events available.\nCreate a new event to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return Column(
                children: [
                  _buildBloodDonationCard(
                    event: event,
                    isExpanded: _isExpandedList[index],
                    onInterested: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You are interested in ${event.name}!',
                          ),
                        ),
                      );
                    },
                    onExpand: () {
                      setState(() {
                        _isExpandedList[index] =
                        !_isExpandedList[index];
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final newEvent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateEventScreen(),
                    ),
                  );
                  if (newEvent != null && newEvent is Event) {
                    setState(() {
                      _events.add(newEvent);
                      _isExpandedList.add(false);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFAF0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                        color: Color(0xffEF2A39), width: 2.0),
                  ),
                ),
                child: const Text(
                  'Create an Event',
                  style: TextStyle(color: Color(0xffEF2A39)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodDonationCard({
    required Event event,
    required bool isExpanded,
    required VoidCallback onInterested,
    required VoidCallback onExpand,
  }) {
    return GestureDetector(
      onTap: onExpand,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
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
                            event.date.split('-')[2],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            _getMonth(event.date),
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
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16.0, color: Colors.grey),
                            const SizedBox(width: 4.0),
                            Text(
                              event.time,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            const SizedBox(width: 16.0),
                            const Icon(Icons.location_on,
                                size: 16.0, color: Colors.grey),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                event.venue,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (isExpanded)
                ...[
                  Text(
                    event.description,
                    style:
                    TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 16.0),
                ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onInterested,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF2A39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Interested',
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
