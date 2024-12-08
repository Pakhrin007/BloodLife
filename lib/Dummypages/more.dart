import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:bloodlife/api/api.dart';
import 'package:bloodlife/pages/eventhistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchuserdetails();
  }

  Future<void> fetchuserdetails() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    "Personal Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "FullName",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "${userData?['FullName'] ?? 'Loading...'}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        "E-Mail",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        "${userData?['Email'] ?? 'Loading...'}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        "PhoneNumber",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        "${userData?['PhoneNumber'] ?? 'Loading...'}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        "Date-of-Birth",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        "${userData?['DateOfBirth'] ?? 'Loading...'}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Api()));
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 20, left: 20)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              child: Text(
                                "Blogs",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Eventhistory()));
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              child: Text(
                                "Event History",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            child: Text(
                              "Donation History",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: SizedBox(
                      width: 150, // Set your desired width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginpage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEF2A39),
                          foregroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Align text and icon
                          children: [
                            Text(
                              "Logout",
                              style:
                                  TextStyle(fontSize: 18, letterSpacing: 1.2),
                            ),
                            SizedBox(width: 9),
                            Icon(Icons.logout),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
