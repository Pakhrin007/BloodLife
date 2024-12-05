import 'package:bloodlife/DonorsSectionPages/dashboard.dart';
import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Signuppages extends StatefulWidget {
  const Signuppages({super.key});

  @override
  State<Signuppages> createState() => _SignuppagesState();
}

class _SignuppagesState extends State<Signuppages> {
  TextEditingController dobController = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  SignUp() async {
    if (email.text.isEmpty ||
        password.text.isEmpty ||
        confirmpassword.text.isEmpty ||
        fullname.text.isEmpty ||
        dobController.text.isEmpty ||
        phonenumber.text.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    if (password.text != confirmpassword.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      await addUserDetails(fullname.text, dobController.text, phonenumber.text);

      Get.snackbar("Success", "Sign Up Successful",
          backgroundColor: Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future addUserDetails(String fullname, String dob, String phoneNumber) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'FullName': fullname,
        'DateOfBirth': dob,
        'PhoneNumber': phoneNumber,
        'Email': email.text
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to add user details: $e");
    }
  }

  // Function to show the date picker
  Future<void> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        dobController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 138, left: 130),
                    child: Container(
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            letterSpacing: 1.6,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170),
            child: Container(
              height: 680,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 368,
                        child: TextField(
                          controller: fullname,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: const Text("Full Name"),
                            hintText: 'Enter Your Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 60,
                        width: 368,
                        child: TextField(
                          controller: dobController,
                          readOnly: true,
                          onTap: () => selectDate(context),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: const Text("DOB"),
                            hintText: 'Select Your DOB',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 60,
                        width: 368,
                        child: TextField(
                          controller: phonenumber,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: const Text("Phone Number"),
                            hintText: 'Enter Your Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 60,
                        width: 368,
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: const Text("E-mail"),
                            hintText: 'Enter Your Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 60,
                        width: 368,
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: const Text("Password"),
                            hintText: 'Enter Your Password',
                            suffixIcon: const Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 60,
                        width: 368,
                        child: TextField(
                          controller: confirmpassword,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: const Text("Confirm Password"),
                            hintText: 'Enter Your Password',
                            suffixIcon: const Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: SignUp,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(
                                239,
                                42,
                                57,
                                0.9,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Container(
                        child: const Text(
                          "Or SignUp With",
                          style: TextStyle(
                              letterSpacing: 1.4,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 110, top: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 55,
                              width: 55,
                              child: Image.asset(
                                  'assets/Images/Icons/facebook.png'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 55,
                              width: 55,
                              child:
                                  Image.asset('assets/Images/Icons/Google.png'),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/Images/Icons/x.png'),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 94, bottom: 35),
                        child: Row(
                          children: [
                            Container(
                              child: const Text(
                                "Already Have Account?",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Loginpage(),
                                  ),
                                );
                              },
                              child: Container(
                                child: Text(
                                  "SignIn",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.9,
                                      fontSize: 16,
                                      color: Colors.red.shade400),
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
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 220,
              width: 400,
              child: Image.asset(
                fit: BoxFit.cover,
                'assets/Images/Logo/Logo.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
