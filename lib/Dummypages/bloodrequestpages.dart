import 'package:bloodlife/models/BloodRequest.dart';
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
  Future<void> acceptBloodRequest(String requestId, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userName = await fetchUserName(user.uid);

      await FirebaseFirestore.instance.collection('bloodRequests').doc(requestId).update({
        'acceptedById': user.uid, // Store the user ID
        'acceptedBy': userName,   // Store the user name
        'isAccepted': true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request accepted')),
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
                  .collection('bloodRequests')
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
                                          onTap: isEligibleToDonate
                                              ? () async {
                                            await acceptBloodRequest(bloodRequest.id, context);
                                          }
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                                            child: Container(
                                              height: 35,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: isEligibleToDonate
                                                    ? Colors.green
                                                    : Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  isAccepted ? "Accepted" : (isEligibleToDonate ? "Accept" : "Not Eligible"),
                                                  style: TextStyle(
                                                    color: isEligibleToDonate
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 230,
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
                                    child: Row(
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
                                              style: TextStyle(fontFamily: 'Poppins-light'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        GestureDetector(
                                          onTap: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('bloodRequests')
                                                  .doc(bloodRequest.id)
                                                  .delete();
                                              Get.snackbar("Delete", "Successfully Deleted",
                                                  backgroundColor: Colors.green);
                                            } catch (e) {
                                              Get.snackbar("Error", "Something went wrong",
                                                  backgroundColor: Colors.red);
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
                                                style: TextStyle(fontFamily: 'Poppins-light'),
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
