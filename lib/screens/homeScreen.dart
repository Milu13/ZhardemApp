import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zhardem/screens/chatScreen.dart';
import 'package:zhardem/screens/mapScreen.dart';
import 'package:zhardem/screens/profileScreen.dart';
import 'package:zhardem/screens/sosScreen.dart';
import 'package:provider/provider.dart';
import '../models/themeModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
       SosScreen(),
      const MapScreen(),
      ChatScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: GNav(
            onTabChange: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            gap: 10,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            color: Colors.black,
            activeColor: Colors.red.shade700,
            padding: const EdgeInsets.all(5),
            tabs: [
              GButton(
                icon: Icons.error,
                iconSize: 35,
                iconColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              GButton(
                icon: Icons.map_outlined,
                iconSize: 35,
                iconColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              GButton(
                icon: Icons.chat,
                iconSize: 35,
                iconColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              GButton(
                icon: Icons.person,
                iconSize: 35,
                iconColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
