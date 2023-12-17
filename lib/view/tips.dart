import 'package:flutter/material.dart';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/models/user.dart';
import 'package:project_fyp/view/loginscreen.dart';
import 'dart:ui';

class TipsPage extends StatefulWidget {
  const TipsPage({
    Key? key, required User user, required Slot slot, required Dry dry,
  }) : super(key: key);

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
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
                Color.fromARGB(255, 76, 135, 219),
                Color.fromARGB(255, 23, 92, 212),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
               Padding(
                padding: EdgeInsets.only(top: 75, left: 50),
                child: Text(
                  "   Tips Wash & Dry",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
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
                      image: AssetImage(
                        'assets/images/L.png',
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 150,
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
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child:  Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Read Tip Wash",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "1.Sort Clothes: Separate your \nlaundry into different piles \nbased on color and fabric type. ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
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
                                      color: Colors.white.withOpacity(0.2)),
                                ),
                                child:  Column(children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Read Tip Dry",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "1.Read Care Labels (Again): Just as \nwith washing, check care labels \nfor drying instructions.",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
