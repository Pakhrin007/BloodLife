import 'package:bloodlife/Dummypages/bloodrequestpage.dart';
import 'package:bloodlife/Dummypages/fav.dart';
import 'package:bloodlife/Dummypages/more.dart';
import 'package:bloodlife/Dummypages/events.dart';
import 'package:bloodlife/mappages/maps.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int index = 2;

  final screen = [
    const MapPage(),
    EventsPage(),
    const Fav(),
    BloodRequestsPage(),
    const More()
  ];

  final items = <Widget>[
    const Icon(
      Icons.map_outlined,
      size: 35,
    ),
    const Icon(
      Icons.add,
      size: 35,
    ),
    const Icon(
      Icons.home,
      size: 35,
    ),
    const Icon(
      Icons.bloodtype_outlined,
      size: 35,
    ),
    const Icon(
      Icons.more_horiz_rounded,
      size: 35,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,

      body: screen[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: const IconThemeData(color: Colors.black)),
        child: CurvedNavigationBar(
          color: Color(0xFFEF2A39),
          buttonBackgroundColor: Colors.white,
          height: 65,
          index: index,
          items: items,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
        ),
      ),
    );
  }
}
