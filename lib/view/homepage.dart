import 'package:flutter/material.dart';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/models/user.dart';
import 'package:project_fyp/view/appointment.dart';
import 'package:project_fyp/view/dry_bookpage.dart';
import 'package:project_fyp/view/profilescreen.dart';
import 'package:project_fyp/view/wash_bookpage.dart';
import 'package:project_fyp/view/loginscreen.dart';
import 'package:project_fyp/view/tips.dart';

import 'dart:ui';

class HomePage extends StatefulWidget {
  final User user;
  final Slot slot;
  final Dry dry;

  const HomePage({
    Key? key,
    required this.user,
    required this.slot,
    required this.dry,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _currentIndex = 0;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 135, 175, 231),
                Color.fromARGB(255, 37, 103, 216),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Text(
                "   Hi, ${widget.user.name}",
                style: TextStyle(
                  height: 5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "   Welcome To Easy Laundry, ",
                style: TextStyle(
                  height: 8,
                  fontSize: 22,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 180, top: 0),
                child: Container(
                  height: 80,
                  width: 200,
                  margin: const EdgeInsets.only(left: 120),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      image: AssetImage('assets/images/L.png'),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 230,
                      width: 330,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 70,),
                                  child: Text(
                                          "Laundry Services",
                                          style: TextStyle(
                                              color: Colors.black,
                                              height: 2,
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WashBookPage(
                                              slot: widget.slot,
                                              user: widget.user,
                                              dry: widget.dry,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              height: 95,
                                              width: 95,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                        12, 123, 95, 1)
                                                    .withOpacity(0.3),
                                                image: const DecorationImage(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  image: AssetImage(
                                                    'assets/images/wash.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Wash",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20, // Adjust spacing
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DryBookPage(
                                              user: widget.user,
                                              slot: widget.slot,
                                              dry: widget.dry,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              height: 95,
                                              width: 95,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 226, 159, 59)
                                                    .withOpacity(0.4),
                                                image: const DecorationImage(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  image: AssetImage(
                                                    'assets/images/dry.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Dry",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 230,
                      width: 330,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 160,),
                                  child: Text(
                                          "For You",
                                          style: TextStyle(
                                              color: Colors.black,
                                              height: 2,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentPage(
                                              user: widget.user,
                                              slot: widget.slot,
                                              dry: widget.dry,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              height: 95,
                                              width: 95,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                        12, 123, 95, 1)
                                                    .withOpacity(0.3),
                                                image: const DecorationImage(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  image: AssetImage(
                                                    'assets/images/history.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "History",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20, // Adjust spacing
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TipsPage(
                                              user: widget.user,
                                              slot: widget.slot,
                                              dry: widget.dry,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              height: 95,
                                              width: 95,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 226, 159, 59)
                                                    .withOpacity(0.4),
                                                image: const DecorationImage(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  image: AssetImage(
                                                    'assets/images/tips.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Tips",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });

                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              user: widget.user,
                              slot: widget.slot,
                              dry: widget.dry,
                            ),
                          ),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentPage(
                              user: widget.user,
                              slot: widget.slot,
                              dry: widget.dry,
                            ),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              user: widget.user,
                              slot: widget.slot,
                              dry: widget.dry,
                            ),
                          ),
                        );
                        break;
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history_outlined),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
