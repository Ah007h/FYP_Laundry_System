import 'package:flutter/material.dart';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/models/user.dart'; // Make sure to import the User class

import 'view/splashscreen.dart';

void main() {
  final Slot slot = Slot(
    slotId: 'your_slot_id',
    user: User(
      // Create a User object
      id: '', name: '', email: '', phone: '', regdate: '',
      // Add other user properties here
    ),
    slotTime: '',
    slotStatus: '',
    slotDate: '', appointmentTypeWash: '',
  );
   final Dry dry = Dry(
    dryId: 'your_dry_id',
    user: User(
      // Create a User object
      id: '', name: '', email: '', phone: '', regdate: '',
      // Add other user properties here
    ),
    dryTime: '',
    dryStatus: '',
    dryDate: '', appointmentType: '',
  );

  runApp(MyApp(slot: slot, dry: dry));
}

class MyApp extends StatefulWidget {
  final Slot slot;
   final Dry dry;
  const MyApp({Key? key, required this.slot, required this.dry}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'FYP Project',
      home: SplashScreen(slot: widget.slot, dry: widget.dry,),
    );
  }
}
