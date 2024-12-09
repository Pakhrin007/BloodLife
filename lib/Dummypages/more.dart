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
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins-Medium",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "FullName:",
                    style: TextStyle(
                        fontSize: 16, fontFamily: "Poppins-Medium"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "${userData?['FullName'] ?? 'Loading...'}",
                    style: const TextStyle(
                        fontSize: 16, fontFamily: "Poppins-Light"),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "E-Mail:",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Medium"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "${userData?['Email'] ?? 'Loading...'}",
                  style: const TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Light"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "PhoneNumber:",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Medium"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "${userData?['PhoneNumber'] ?? 'Loading...'}",
                  style: const TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Light"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "Date-of-Birth:",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Medium"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "${userData?['DateOfBirth'] ?? 'Loading...'}",
                  style: const TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Light"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "Blood Type:",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Medium"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 13),
                child: Text(
                  "${userData?['BloodType'] ?? 'Loading...'}",
                  style: const TextStyle(
                      fontSize: 16, fontFamily: "Poppins-Light"),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15),
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
                child: const ListTile(
                  title: Text(
                    "Blogs",
                    style: TextStyle(
                        fontSize: 16, fontFamily: "Poppins-Medium"),
                  ),
                  trailing: Icon(Icons.arrow_circle_right_outlined),
                ),
              ),
              const Divider(color: Colors.grey, thickness: 1),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Eventhistory()));
                },
                child: const ListTile(
                  title: Text(
                    "Event History",
                    style: TextStyle(
                        fontSize: 16, fontFamily: "Poppins-Medium"),
                  ),
                  trailing: Icon(Icons.arrow_circle_right_outlined),
                ),
              ),
              const Divider(color: Colors.grey, thickness: 1),
              GestureDetector(
                onTap: () {
                  // Navigate to Donation History
                },
                child: const ListTile(
                  title: Text(
                    "Donation History",
                    style: TextStyle(
                        fontSize: 16, fontFamily: "Poppins-Medium"),
                  ),
                  trailing: Icon(Icons.arrow_circle_right_outlined),
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Loginpage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF2A39),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1.2,
                            fontFamily: "Poppins-Medium"),
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
