import 'package:bloodlife/pages/createBloodRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bloodrequestpage extends StatefulWidget {
  const Bloodrequestpage({super.key});

  @override
  State<Bloodrequestpage> createState() => _BloodrequestpageState();
}

class _BloodrequestpageState extends State<Bloodrequestpage> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  String? userBloodType;
  String? acceptedByName;
  @override
  void initState() {
    super.initState();
    fetchUserBloodType();
  }
  Future<String?> fetchUserContact(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc['PhoneNumber'] ?? 'N/A'; // Returns contact number or 'N/A' if not available
    } catch (e) {
      print('Error fetching user contact number: $e');
      return null;
    }
  }
  Future<String?> fetchUserName(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc['FullName'] ?? 'Unknown User';
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }
  Future<void> fetchUserBloodType() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists || userDoc['BloodType'] == null) {
        return;
      }

      setState(() {
        userBloodType = userDoc['BloodType'];
      });
    } catch (e) {
      print("Error fetching user blood type: $e");
      Get.snackbar('Error', 'Failed to fetch user blood type',
          backgroundColor: Colors.red);
    }
  }
  Future<void> acceptBloodRequest(String requestId, String requestUserId, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      if (user.uid == requestUserId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You cannot accept your own request')),
        );
        return;
      }

      final userName = await fetchUserName(user.uid);

      await FirebaseFirestore.instance.collection('bloodRequests').doc(requestId).update({
        'acceptedById': user.uid, // Store the user ID
        'acceptedBy': userName,   // Store the user name
        'isAccepted': true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting request: $e')),
      );
    }
  }


  bool canDonate(String donorType, String recipientType) {
    final compatibility = {
      'A+': ['A+', 'AB+'],
      'A-': ['A+', 'A-', 'AB+', 'AB-'],
      'B+': ['B+', 'AB+'],
      'B-': ['B+', 'B-', 'AB+', 'AB-'],
      'AB+': ['AB+'],
      'AB-': ['AB+', 'AB-'],
      'O+': ['A+', 'B+', 'AB+', 'O+'],
      'O-': ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
    };
    return compatibility[donorType]?.contains(recipientType) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Requests List"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "All Request"),
              Tab(text: "My request"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bloodRequests').where('isAccepted', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data Available"));
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

                    final isEligibleToDonate =
                        userBloodType != null && canDonate(userBloodType!, recipientBloodType);

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.cyan.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(Icons.person),
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
                                            "Additional Info: ${bloodRequest["additionalInfo"]}",
                                            style: const TextStyle(fontFamily: 'Poppins-Light'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Blood Type: $recipientBloodType",
                                            style: const TextStyle(fontFamily: 'Poppins-Light'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Contact Number: ${bloodRequest["contactNumber"]}",
                                            style: const TextStyle(fontFamily: 'Poppins-Light'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Location: ${bloodRequest["location"]}",
                                            style: const TextStyle(fontFamily: 'Poppins-Light'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Needed Date: ${bloodRequest["neededDate"]}",
                                            style: const TextStyle(fontFamily: 'Poppins-Light'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Name: ${bloodRequest["patientName"]}",
                                            style: const TextStyle(fontFamily: 'Poppins-Light'),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              // Other widgets
                                              if (acceptedBy != null && acceptedBy.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "Accepted by: $acceptedBy",
                                                    style: const TextStyle(fontFamily: 'Poppins-Bold'),
                                                  ),
                                                ),
                                              // Other widgets
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: isEligibleToDonate && (bloodRequest['userId'] != currentUserId)
                                              ? () async {
                                            try {
                                              // Calculate next donation date dynamically
                                              DateTime? appointmentDate;
                                              DateTime? bloodRequestDate;

                                              final QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
                                                  .collection('appointments')
                                                  .where('userId', isEqualTo: currentUserId)
                                                  .orderBy('appointmentDate', descending: true)
                                                  .limit(1)
                                                  .get();

                                              if (appointmentSnapshot.docs.isNotEmpty) {
                                                final appointmentDoc = appointmentSnapshot.docs.first;
                                                appointmentDate = DateTime.parse(appointmentDoc['appointmentDate']);
                                              }

                                              final QuerySnapshot bloodRequestSnapshot = await FirebaseFirestore.instance
                                                  .collection('bloodRequests')
                                                  .where('acceptedById', isEqualTo: currentUserId)
                                                  .limit(1)
                                                  .get();

                                              if (bloodRequestSnapshot.docs.isNotEmpty) {
                                                final bloodRequestDoc = bloodRequestSnapshot.docs.first;
                                                final neededDate = bloodRequestDoc['neededDate'];
                                                bloodRequestDate = DateTime.parse(neededDate);
                                              }

                                              DateTime? latestDate;
                                              if (appointmentDate != null && bloodRequestDate != null) {
                                                latestDate = appointmentDate.isAfter(bloodRequestDate) ? appointmentDate : bloodRequestDate;
                                              } else if (appointmentDate != null) {
                                                latestDate = appointmentDate;
                                              } else if (bloodRequestDate != null) {
                                                latestDate = bloodRequestDate;
                                              }

                                              final nextDonationDate = latestDate?.add(const Duration(days: 85));

                                              // Check eligibility
                                              if (nextDonationDate != null && DateTime.now().isBefore(nextDonationDate)) {
                                                final remainingDays = nextDonationDate.difference(DateTime.now()).inDays;
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Donation Not Allowed",
                                                        style: TextStyle(
                                                          fontFamily: "Poppins-Medium",
                                                          fontSize: 20,
                                                          color: Colors.redAccent,  // You can use a custom color
                                                        ),
                                                      ),
                                                      content: Text(
                                                        "You can donate again in $remainingDays day(s). Please wait until your next eligible donation date.",
                                                        style: const TextStyle(
                                                          fontFamily: "Poppins-Light",
                                                          fontSize: 16,
                                                          color: Colors.black87,  // A darker color for readability
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text(
                                                            "OK",
                                                            style: TextStyle(
                                                              fontFamily: "Poppins-Medium",
                                                              fontSize: 16,
                                                              color: Colors.blue,  // A different color for the button text
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                // Proceed to accept the blood request
                                                await acceptBloodRequest(bloodRequest.id, bloodRequest['userId'], context);
                                              }
                                            } catch (e) {
                                              print('Error calculating next donation date: $e');
                                            }
                                          }
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                                            child: Container(
                                              height: 35,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: isEligibleToDonate && (bloodRequest['userId'] != currentUserId)
                                                    ? Colors.green
                                                    : Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  isAccepted
                                                      ? "Accepted"
                                                      : (isEligibleToDonate && (bloodRequest['userId'] != currentUserId)
                                                      ? "Accept"
                                                      : "Not Eligible"),
                                                  style: TextStyle(
                                                    color: isEligibleToDonate &&
                                                        (bloodRequest['userId'] != currentUserId)
                                                        ? Colors.white
                                                        : Colors.black54,
                                                    fontFamily: 'Poppins-Medium',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bloodRequests')
                  .where('userId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data Available"));
                }
                final bloodRequests = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: bloodRequests.length,
                  itemBuilder: (context, index) {
                    final bloodRequest = bloodRequests[index];
                    final isAccepted = bloodRequest['isAccepted'] ?? false;
                    final acceptedBy = bloodRequest['acceptedBy'];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Basic Information
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Additional Info: ${bloodRequest["additionalInfo"]}",
                                      style: const TextStyle(fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Blood Type: ${bloodRequest["bloodType"]}",
                                      style: const TextStyle(fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Contact Number: ${bloodRequest["contactNumber"]}",
                                      style: const TextStyle(fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Location: ${bloodRequest["location"]}",
                                      style: const TextStyle(fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Needed Date: ${bloodRequest["neededDate"]}",
                                      style: const TextStyle(fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Name: ${bloodRequest["patientName"]}",
                                      style: const TextStyle(fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (isAccepted) ...[
                                          Text(
                                            "Accepted by: $acceptedBy",
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              fontSize: 16,
                                            ),
                                          ),
                                          FutureBuilder<String?>(
                                            future: fetchUserContact(bloodRequest['acceptedById']),
                                            builder: (context, contactSnapshot) {
                                              if (contactSnapshot.connectionState == ConnectionState.waiting) {
                                                return const Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: CircularProgressIndicator(),
                                                );
                                              } else if (contactSnapshot.hasError) {
                                                return const Text("Error fetching contact");
                                              } else {
                                                final contact = contactSnapshot.data ?? 'N/A';
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    "Contact: $contact",
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins-Bold',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ] else ...[
                                          Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins-Light',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              GestureDetector(
                                                onTap: () async {
                                                  try {
                                                    await FirebaseFirestore.instance
                                                        .collection('bloodRequests')
                                                        .doc(bloodRequest.id)
                                                        .delete();
                                                    Get.snackbar(
                                                      "Delete",
                                                      "Request successfully deleted",
                                                      backgroundColor: Colors.green,
                                                    );
                                                  } catch (e) {
                                                    Get.snackbar(
                                                      "Error",
                                                      "Something went wrong",
                                                      backgroundColor: Colors.red,
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(fontFamily: 'Poppins-Light'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  CreateBloodRequestScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.red,
            shadows: [Shadow(blurRadius: 1)],
          ),
        ),
      ),
    );
  }
}