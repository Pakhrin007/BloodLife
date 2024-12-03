import 'package:bloodlife/api/api.dart';
import 'package:flutter/material.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Text("Personal Details"),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Name"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Aryan"),
              ),
            ],
          ),
          Row(
            children: [
              Text("E-Mail"),
            ],
          ),
          Row(
            children: [
              Text("Date of Birth"),
            ],
          ),
          Row(
            children: [
              Text("Phone Number"),
            ],
          ),
          Row(
            children: [
              Text("Gender"),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Row(
            children: [
              Container(
                child: Text(
                  "Donation History",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_circle_right,
                color: Colors.black,
                size: 24.0,
              ),
              SizedBox(width: 8),
            ],
          ),
          Row(
            children: [Text("Last Donation")],
          ),
          Row(
            children: [Text("Phone Number"), Text("2004-08-200")],
          ),
          Row(
            children: [Text("Phone Number"), Text("9810191682")],
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Column(
            children: [
              Text("Time Left for Notification"),
              Container(
                decoration: BoxDecoration(color: Colors.red.shade400),
                child: Text("70 Days"),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    child: Text("Medical details"),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              ),
              Divider(
                color: Colors.grey, // Color of the line
                thickness: 1, // Thickness of the line
                indent: 10, // Left margin
                endIndent: 10, // Right margin
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Api()));
                },
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      child: Text("Blogs"),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_circle_right_outlined),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    child: Text("Event History"),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
