import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/models/user.dart';
import 'package:project_fyp/view/homepage.dart';

class SuccessPage extends StatefulWidget {
  final User user;
  final Slot slot;
  final Dry dry;
  const SuccessPage(
      {Key? key, required this.user, required this.slot, required this.dry})
      : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(user: widget.user, slot: widget.slot, dry: widget.dry,),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200, // Specify your desired width
              height: 150, // Specify your desired height
              child: Lottie.asset('assets/images/success_animation.json'),
            ),
            Text(
              'Booking Successful!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
