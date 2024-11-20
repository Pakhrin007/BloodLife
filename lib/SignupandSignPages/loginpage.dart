import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(
                239,
                42,
                57,
                0.9,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child: Container(
              // height: 100,
              // width: 600,
              child: Stack(
                children: [
                  Container(
                    height: 30,
                    width: 40,
                    child: Image.asset('assets/Images/Logo/Logo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 66, left: 10),
                    child: Container(
                      child: Text(
                        "Login to Your Account",
                        style: TextStyle(
                            letterSpacing: 1.6,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 160),
            child: Container(
              height: 660,
              width: double.infinity,
              decoration: BoxDecoration(
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
                      height: 25,
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
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 190),
                      child: Container(
                        child: Text("Forgot Password ?"),
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
                            "Login",
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
                        "Or Signin With",
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
                            child:
                                Image.asset('assets/Images/Icons/facebook.png'),
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
                      padding: const EdgeInsets.only(left: 105),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Don't Have Account?",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.9,
                                  fontSize: 16,
                                  color: Colors.red.shade400),
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
        ],
      ),
    );
  }
}
