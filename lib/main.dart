import 'package:bloodlife/DonorsSectionPages/dashboard.dart';
import 'package:bloodlife/Dummypages/more.dart';
import 'package:bloodlife/SignupandSignPages/forgotpassword.dart';
import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:bloodlife/api/api.dart';
import 'package:bloodlife/pages/createBloodRequest.dart';
import 'package:bloodlife/pages/createEvent.dart';
import 'package:bloodlife/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // cheking git changes
  // git branch
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Forgotpassword(),
    );
  }
}
