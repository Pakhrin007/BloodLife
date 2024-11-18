import 'package:bloodlife/Dummypages/fav.dart';
import 'package:bloodlife/Dummypages/home.dart';
import 'package:bloodlife/Dummypages/profile.dart';
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

  final screen = [
    Home(),
    // Replace `SearchBar()` with a valid widget
    Center(child: Text("Search Page Placeholder")),
    Fav(),
    Setting(),
    Profile()
  ];

  final items = <Widget>[
    Icon(
      Icons.home,
      size: 30,
    ),
    Icon(
      Icons.search,
      size: 30,
    ),
    Icon(
      Icons.favorite,
      size: 30,
    ),
    Icon(
      Icons.settings,
      size: 30,
    ),
    Icon(
      Icons.person,
      size: 30,
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
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.black),
        ),
        child: CurvedNavigationBar(
          color: Colors.red.shade400,
          buttonBackgroundColor: Colors.white,
          height: 60,
          index: index,
          items: items,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeOut,
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
