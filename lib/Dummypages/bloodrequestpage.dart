import 'package:flutter/material.dart';
import '../pages/createBloodRequest.dart';

class BloodRequestsPage extends StatefulWidget {
  @override
  _BloodRequestsPageState createState() => _BloodRequestsPageState();
}

class _BloodRequestsPageState extends State<BloodRequestsPage> {
  List<Map<String, dynamic>> bloodRequests = [];

  // List to track which card is expanded
  List<bool> _isExpandedList = [];

  // Function to navigate to CreateBloodRequestScreen and add a new request
  Future<void> _createBloodRequest() async {
    final newRequest = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBloodRequestScreen(),
      ),
    );

    if (newRequest != null) {
      setState(() {
        bloodRequests.add(newRequest); // Add new request to the list
        _isExpandedList.add(false); // Initialize the expanded state for the new request
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Blood Requests",
          style: TextStyle(color: Colors.black, fontFamily: "Poppins-Medium"),
        ),
      ),
      body: Stack(
        children: [
          // If no blood requests, show a message
          bloodRequests.isEmpty
              ? Center(
            child: Text(
              'No blood requests yet.\nCreate a new request to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          )
              : ListView.builder(

            padding: const EdgeInsets.all(16.0),
            itemCount: bloodRequests.length,
            itemBuilder: (context, index) {
              final request = bloodRequests[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the expanded state for this request
                        _isExpandedList[index] = !_isExpandedList[index];
                      });
                    },
                    child: _buildBloodRequestCard(request: request, isExpanded: _isExpandedList[index]),
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
          // Floating button to create a new blood request
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _createBloodRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFAF0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color(0xffEF2A39), width: 2.0),
                  ),
                ),
                child: const Text(
                  'Create a Blood Request',
                  style: TextStyle(color: Color(0xffEF2A39)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build individual blood request card widget with expanded details
  Widget _buildBloodRequestCard({required Map<String, dynamic> request, required bool isExpanded}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.pink[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Icon and Patient Details
            Row(
              children: [
                const Icon(
                  Icons.bloodtype,
                  color: Colors.red,
                  size: 40.0,
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${request['patientName']}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '${request['location']}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Needed by ${request['neededDate']}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5.0),
                        Text(
                          'Blood Group: ${request['bloodType']}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    // Only show "Urgent" if it's true
                    if (request['urgent'])
                      Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            'Urgent',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // Buttons (Accept and Medical Details)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the accept request action
                    },
                    child: Text('Accept Request'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.pink[100],
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the medical details screen
                    },
                    icon: Icon(Icons.description),
                    label: Text('Medical Details'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.pink[100],
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
              ],
            ),
            // Expanded Description Section (if expanded)
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  request['additionalInfo'] ?? 'No info',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
