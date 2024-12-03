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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              height: 65,
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Event List",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEventScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF2A39),
                  foregroundColor: Colors.white,
                ),
                child: Text('Add Event'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
