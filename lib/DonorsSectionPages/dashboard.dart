import 'package:bloodlife/Dummypages/fav.dart';
import 'package:bloodlife/Dummypages/home.dart';
import 'package:bloodlife/Dummypages/profile.dart';
import 'package:bloodlife/Dummypages/search.dart';
import 'package:bloodlife/Dummypages/setting.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int index = 2;

  final screen = [Home(), Search(), Fav(), Setting(), Profile()];

  final items = <Widget>[
    Icon(
      Icons.home,
      size: 35,
    ),
    Icon(
      Icons.search,
      size: 35,
    ),
    Icon(
      Icons.favorite,
      size: 35,
    ),
    Icon(
      Icons.settings,
      size: 35,
    ),
    Icon(
      Icons.person,
      size: 35,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        title: Text("Curved Navigation Bar"),
        centerTitle: true,
      ),
      body: screen[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.black)),
        child: CurvedNavigationBar(
          color: Colors.red.shade400,
          buttonBackgroundColor: Colors.white,
          height: 65,
          index: index,
          items: items,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeIn,
          animationDuration: Duration(milliseconds: 300),
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
