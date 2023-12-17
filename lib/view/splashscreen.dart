import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  final Slot slot;
  final Dry dry;
  const SplashScreen({super.key, required this.slot, required this.dry});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => LoginScreen(slot: widget.slot, dry: widget.dry,),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Add the Image.asset widget with your local GIF image here
            Expanded(
              child: Image.asset(
                'assets/images/EASY_Laundry.gif',
                fit: BoxFit.cover, // Ensure the image covers the available space
              ),
            ),
          ],
        ),
      ),
    );
  }
}
