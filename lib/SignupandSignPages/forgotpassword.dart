import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController email = TextEditingController();
  sendlink() async {
    if (email.text.isEmpty) {
      Get.snackbar("Error", "Please fill the textfeid");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Get.snackbar("Send", "sucessfully sent the link");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
    } catch (e) {
      Get.snackbar("Error", "Something wrong $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 10),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 368,
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  label: const Text("E-mail"),
                  hintText: 'Enter Your E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: sendlink,
              child: Container(
                height: 50,
                width: 130,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    "send Link",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
