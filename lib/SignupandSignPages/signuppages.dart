import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:flutter/material.dart';

class Signuppages extends StatefulWidget {
  const Signuppages({super.key});

  @override
  State<Signuppages> createState() => _SignuppagesState();
}

class _SignuppagesState extends State<Signuppages> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 138, left: 33),
                    child: Container(
                      child: Text(
                        "SignUp to Your Account",
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
              decoration: BoxDecoration(
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
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("Full Name"),
                            hintText: 'Enter Your Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("Blood Type"),
                            hintText: 'Enter Your Blood Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("DOB"),
                            hintText: 'Enter Your DOB',
                            suffixIcon: Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("Phone Number"),
                            hintText: 'Enter Your Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("E-mail"),
                            hintText: 'Enter Your Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("Password"),
                            hintText: 'Enter Your Password',
                            suffixIcon: Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: 368,
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text("Confirm Password"),
                            hintText: 'Enter Your Password',
                            suffixIcon: Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(
                              239,
                              42,
                              57,
                              0.9,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
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
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        child: Text(
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
                            Container(
                              height: 55,
                              width: 55,
                              child: Image.asset(
                                  'assets/Images/Icons/facebook.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 55,
                              width: 55,
                              child:
                                  Image.asset('assets/Images/Icons/Google.png'),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/Images/Icons/x.png'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 94, bottom: 35),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                "Already Have Account?",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Loginpage(),
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
            child: Container(
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
