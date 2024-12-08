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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Requests List"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "All Request",
              ),
              Tab(
                text: "My request",
              )
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No data Available"),
                  );
                }
                final bloodRequests = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: bloodRequests.length,
                  itemBuilder: (context, index) {
                    final bloodrequest = bloodRequests[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.cyan.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Additional Info: ${bloodrequest["additionalInfo"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "BloodType: ${bloodrequest["bloodType"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "contactNumber: ${bloodrequest["contactNumber"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Location: ${bloodrequest["location"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Needed Date: ${bloodrequest["neededDate"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Name: ${bloodrequest["patientName"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      height: 40,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: Text(
                                        "Accept",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Poppins-Medium'),
                                      )),
                                    ),
                                  )
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bloodRequests')
                  .where('userId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No data Available"),
                  );
                }
                final bloodRequests = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: bloodRequests.length,
                  itemBuilder: (context, index) {
                    final bloodrequest = bloodRequests[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.cyan.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Additional Info: ${bloodrequest["additionalInfo"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "BloodType: ${bloodrequest["bloodType"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "contactNumber: ${bloodrequest["contactNumber"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Location: ${bloodrequest["location"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Needed Date: ${bloodrequest["neededDate"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Name: ${bloodrequest["patientName"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: Text(
                                                "pending",
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-light'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('bloodRequests')
                                                    .doc(bloodrequest.id)
                                                    .delete();
                                                Get.snackbar("Delete",
                                                    "Sucessfully Deleted",
                                                    backgroundColor:
                                                        Colors.green);
                                              } catch (e) {
                                                Get.snackbar("Error",
                                                    "Something went wrong",
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-light'),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateBloodRequestScreen()),
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
