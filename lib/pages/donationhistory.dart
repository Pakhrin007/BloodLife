import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonationHistory extends StatefulWidget {
  const DonationHistory({super.key});

  @override
  State<DonationHistory> createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Donation History",
            style: TextStyle(fontFamily: "Poppins-Medium"),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Appointments"),
              Tab(text: "Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AppointmentHistory(currentUserId: currentUserId),
            RequestHistory(currentUserId: currentUserId),
          ],
        ),
      ),
    );
  }
}

class AppointmentHistory extends StatelessWidget {
  final String? currentUserId;

  const AppointmentHistory({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return currentUserId == null
        ? const Center(
            child: Text("User not logged in."),
          )
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .where('userId', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No data available."),
                );
              }
              final appointments = snapshot.data!.docs;
              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.cyan.shade900,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Donor Name: ${appointment["donorName"]}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Contact Number: ${appointment["contactNumber"]}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Hospital Name: ${appointment["hospitalName"]}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Hospital Address: ${appointment["hospitalAddress"]}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Blood Type : ${appointment["bloodType"]}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Additional Info: ${appointment["additionalInfo"] ?? "None"}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}

class RequestHistory extends StatelessWidget {
  final String? currentUserId;

  const RequestHistory({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bloodRequests')
          .where('acceptedById', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No requests available."),
          );
        }

        final bloodRequests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bloodRequests.length,
          itemBuilder: (context, index) {
            final bloodRequest = bloodRequests[index];
            final recipientBloodType = bloodRequest['bloodType'];
            final acceptedById = bloodRequest['acceptedById'];
            final acceptedBy = bloodRequest['acceptedBy'];
            final isAccepted = bloodRequest['isAccepted'] ?? false;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Icon(Icons.bloodtype_rounded,
                            size: 40, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${bloodRequest["patientName"]}",
                              style: const TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Additional Info: ${bloodRequest["additionalInfo"]}",
                              style:
                                  const TextStyle(fontFamily: 'Poppins-Light'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Blood Type: $recipientBloodType",
                              style:
                                  const TextStyle(fontFamily: 'Poppins-Light'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.phone,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 5),
                                Text(
                                  "${bloodRequest["contactNumber"]}",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-Light'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 5),
                                Text(
                                  "${bloodRequest["location"]}",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-Light'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 5),
                                Text(
                                  "Needed Date: ${bloodRequest["neededDate"]}",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-Light'),
                                ),
                              ],
                            ),
                          ),
                          if (acceptedBy != null && acceptedBy.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Accepted by: $acceptedBy",
                                style:
                                    const TextStyle(fontFamily: 'Poppins-Bold'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

String formatDate(String Date) {
  try {
    final dateTime = DateTime.parse(Date);
    return DateFormat('dd MMM yyy').format(dateTime);
  } catch (e) {
    return 'invalid date';
  }
}
