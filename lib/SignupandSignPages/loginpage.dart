import 'package:bloodlife/DonorsSectionPages/dashboard.dart';
import 'package:bloodlife/SignupandSignPages/forgotpassword.dart';
import 'package:bloodlife/SignupandSignPages/signuppages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  SignIn() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Please fill all the Text fields");
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      Get.snackbar("Login", "Login Successful", backgroundColor: Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 138, left: 38),
                child: const Text(
                  "Log In to Your Account",
                  style: TextStyle(
                    letterSpacing: 1.6,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170),
            child: Container(
              height: 660,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Column(
                  children: [
                    // Email Input
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
                    const SizedBox(height: 25),
                    // Password Input
                    SizedBox(
                      height: 60,
                      width: 368,
                      child: TextField(
                        controller: password,
                        obscureText: true,
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
                    const SizedBox(height: 25),
                    // Forgot Password
                    Padding(
                      padding: const EdgeInsets.only(left: 190),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Forgotpassword()),
                          );
                        },
                        child: const Text("Forgot Password ?"),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Login Button
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          SignIn(); // Trigger the login function
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(239, 42, 57, 0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                    // Sign In With
                    const Text(
                      "Or Sign In With",
                      style: TextStyle(
                        letterSpacing: 1.4,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 110, top: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 55,
                            width: 55,
                            child:
                                Image.asset('assets/Images/Icons/facebook.png'),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 55,
                            width: 55,
                            child:
                                Image.asset('assets/Images/Icons/Google.png'),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset('assets/Images/Icons/x.png'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Don't Have Account? Sign Up
                    Padding(
                      padding: const EdgeInsets.only(left: 105),
                      child: Row(
                        children: [
                          const Text(
                            "Don't Have Account?",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Signuppages(),
                                ),
                              );
                            },
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.9,
                                fontSize: 16,
                                color: Colors.red.shade400,
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
          // Logo at Top
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 225,
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
