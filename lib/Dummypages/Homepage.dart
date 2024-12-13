import 'package:bloodlife/Dummypages/bloodrequestpages.dart';
import 'package:bloodlife/Dummypages/events.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HomePage",
          style: TextStyle(fontSize: 18, fontFamily: 'Poppins-Medium'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bloodrequestpage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.red.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.bloodtype_rounded,
                        size: 40, color: Colors.black54),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "John Doe",
                          style: TextStyle(
                              fontFamily: 'Poppins-Medium', fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Additional Info: Blood transfusion needed",
                          style: TextStyle(fontFamily: 'Poppins-Light'),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Blood Type: O+",
                          style: TextStyle(fontFamily: 'Poppins-Light'),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.phone,
                                size: 16, color: Colors.black54),
                            SizedBox(width: 5),
                            Text(
                              "123-456-7890",
                              style: TextStyle(fontFamily: 'Poppins-Light'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.black54),
                            SizedBox(width: 5),
                            Text(
                              "123 Main Street, City, Country",
                              style: TextStyle(fontFamily: 'Poppins-Light'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.black54),
                            SizedBox(width: 5),
                            Text(
                              "15th December 2024",
                              style: TextStyle(fontFamily: 'Poppins-Light'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "More Info",
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  content: const Text(
                                    "Here is some more information regarding the blood request.",
                                    style: TextStyle(
                                      fontFamily: "Poppins-Light",
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                          fontFamily: "Poppins-Medium",
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Center(
                              child: Text(
                                "More...",
                                style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 18,
                                ),
                              ),
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
          const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 120, top: 10),
                        child: const Text(
                          "All Events",
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'Poppins-Medium'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(child: Text("21\ndec")),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.watch),
                          SizedBox(width: 5),
                          Text("5:15 PM"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.map),
                          SizedBox(width: 5),
                          Text("Event Location"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 110),
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Text(
                              "Interested",
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Poppins-Medium'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 280, top: 1),
                        child: Container(
                          child: Text(
                            "More...",
                            style: TextStyle(
                                fontFamily: 'Poppins-Medium', fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
