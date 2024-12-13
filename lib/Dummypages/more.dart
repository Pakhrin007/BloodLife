import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:bloodlife/api/api.dart';
import 'package:bloodlife/pages/donationhistory.dart';
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
  DateTime? nextDonationDate;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    calculateNextDonationDate();
  }

  Future<void> fetchUserDetails() async {
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

  Future<void> calculateNextDonationDate() async {
    try {
      DateTime? appointmentDate;
      DateTime? bloodRequestDate;

      final QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('appointmentDate', descending: true)
          .limit(1)
          .get();

      if (appointmentSnapshot.docs.isNotEmpty) {
        final appointmentDoc = appointmentSnapshot.docs.first;
        appointmentDate = DateTime.parse(appointmentDoc['appointmentDate']);
      }

      final QuerySnapshot bloodRequestSnapshot = await FirebaseFirestore.instance
          .collection('bloodRequests')
          .where('acceptedById', isEqualTo: user.uid)
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

      if (latestDate != null) {
        setState(() {
          nextDonationDate = latestDate?.add(const Duration(days: 85));
        });
      }
    } catch (e) {
      print('Failed to calculate next donation date: $e');
    }
  }

  Widget buildTimer() {
    if (nextDonationDate == null) {
      return const Text(
        "No donation history found.",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = nextDonationDate!.difference(now);

        if (remaining.isNegative) {
          return const Text(
            "You are now eligible to donate again!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          );
        }

        final days = remaining.inDays;
        final hours = remaining.inHours % 24;
        final minutes = remaining.inMinutes % 60;
        final seconds = remaining.inSeconds % 60;

        Widget buildTimeBox(String label, String value) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTimeBox("Days", "$days"),
            const SizedBox(width: 12),
            buildTimeBox("Hours", "$hours"),
            const SizedBox(width: 12),
            buildTimeBox("Minutes", "$minutes"),
            const SizedBox(width: 12),
            buildTimeBox("Seconds", "$seconds"),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              "Personal Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          buildUserDetails(),
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Divider(color: Colors.grey, thickness: 1, indent: 10),
          ),
          buildOptionRow("Blogs", const Api(), Icons.arrow_circle_right_outlined),
          const Divider(color: Colors.grey, thickness: 1, indent: 10),
          buildOptionRow("Event History", Eventhistory(), Icons.arrow_circle_right_outlined),
          const Divider(color: Colors.grey, thickness: 1, indent: 10),
          buildOptionRow("Donation History", Donationhistory(), Icons.arrow_circle_right_outlined),
          const Divider(color: Colors.grey, thickness: 1, indent: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade100, // Original solid color from the initial code
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Your Next Donation is in:",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins-Medium",
                      color: Colors.red, // Ensures text matches the original color theme
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildTimer(),
                ],
              ),
            ),
          ),
          const Spacer(),
          buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget buildUserDetails() {
    return Column(
      children: [
        buildInfoRow("FullName", "${userData?['FullName'] ?? 'Loading...'}"),
        buildInfoRow("E-Mail", "${userData?['Email'] ?? 'Loading...'}"),
        buildInfoRow("PhoneNumber", "${userData?['PhoneNumber'] ?? 'Loading...'}"),
        buildInfoRow("Date-of-Birth", "${userData?['DateOfBirth'] ?? 'Loading...'}"),
        buildInfoRow("Blood Type", "${userData?['BloodType'] ?? 'Loading...'}"),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 13),
          child: Text(
            "$label:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 13),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget buildOptionRow(String title, Widget page, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Icon(icon),
        ],
      ),
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: buildLogoutDialog(context),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF2A39),
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Logout", style: TextStyle(fontSize: 18, letterSpacing: 1.2)),
                SizedBox(width: 9),
                Icon(Icons.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogoutDialog(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text("Confirm Logout", style: TextStyle(fontSize: 20, fontFamily: "Poppins-Medium")),
              ],
            ),
          ),
          const Text(
            "We still need you here.\nAre you sure you want to log out?",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Poppins-Light", fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(backgroundColor: Colors.grey.shade600),
                child: const Text("Cancel", style: TextStyle(fontSize: 14, fontFamily: "Poppins-Medium", color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                  );
                },
                style: TextButton.styleFrom(backgroundColor: Colors.red.shade600),
                child: const Text("Logout", style: TextStyle(fontSize: 14, fontFamily: "Poppins-Medium", color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}