import 'package:bloodlife/pages/createBloodRequest.dart';
import 'package:bloodlife/pages/createEvent.dart';

import 'package:flutter/material.dart';

class Addevent extends StatefulWidget {
  const Addevent({super.key});

  @override
  State<Addevent> createState() => _AddeventState();
}

class _AddeventState extends State<Addevent> {
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
            "Event List",
            style: TextStyle(fontSize: 18, color: Colors.black),
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffE8D1D1),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
