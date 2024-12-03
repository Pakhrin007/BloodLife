import 'package:bloodlife/pages/createBloodRequest.dart';

import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          height: 65,
          width: double.infinity,
          decoration: BoxDecoration(
              // color: Colors.red.shade200,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Text(
            "Blood Requests",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffE8D1D1),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBloodRequestScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
