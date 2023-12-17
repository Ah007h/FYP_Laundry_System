import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/shared/config.dart';
import 'package:project_fyp/models/user.dart';
import 'package:project_fyp/view/homepage.dart';
import 'package:project_fyp/view/profilescreen.dart';

class AppointmentPage extends StatefulWidget {
  final User user;
  final Slot slot;
  final Dry dry;

  const AppointmentPage(
      {Key? key, required this.user, required this.slot, required this.dry})
      : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<Slot> upcomingAppointments = [];
  List<Slot> completeAppointments = [];
  List<Slot> cancelAppointments = [];
  List<Slot> appointments = [];
  List<Dry> dryAppointments = [];
  List<Dry> upcomingDryAppointments = [];
  List<Dry> completeDryAppointments = [];
  List<Dry> cancelDryAppointments = [];
  int _currentIndex = 0;

  // Step 1: Parse JSON data into Slot objects
  List<Slot> parseSlots(List<dynamic> data) {
    return data.map((json) => Slot.fromJson(json)).toList();
  }

  // Step 2: Parse JSON data into Dry objects
  List<Dry> parseDrySlots(List<dynamic> data) {
    return data.map((json) => Dry.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    loadAppointments();
    loadDryAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      final user_id = widget.user.id;
      final response = await http.get(
        Uri.parse('${ServConfig.Serv}php/viewbook.php?user_id=$user_id'),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          print('Received Data: $data'); // Debugging line

          setState(() {
            appointments = parseSlots(data);
            upcomingAppointments = appointments
                .where((slot) => slot.slotStatus == 'upcoming')
                .toList();
            completeAppointments = appointments
                .where((slot) => slot.slotStatus == 'complete')
                .toList();
            cancelAppointments = appointments
                .where((slot) => slot.slotStatus == 'cancel')
                .toList();
          });
        } else {
          print('Invalid data format');
        }
      } else {
        // Handle error
        print('Failed to load appointments');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  Future<void> loadDryAppointments() async {
    try {
      final user_id = widget.user.id;
      final response = await http.get(
        Uri.parse('${ServConfig.Serv}php/viewbook_dry.php?user_id=$user_id'),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          print('Received Dry Appointments Data: $data'); // Debugging line

          setState(() {
            dryAppointments = parseDrySlots(data);
            upcomingDryAppointments = dryAppointments
                .where((slot) => slot.dryStatus == 'upcoming')
                .toList();
            completeDryAppointments = dryAppointments
                .where((slot) => slot.dryStatus == 'complete')
                .toList();
            cancelDryAppointments = dryAppointments
                .where((slot) => slot.dryStatus == 'cancel')
                .toList();
          });
        } else {
          print('Invalid dry appointments data format');
        }
      } else {
        // Handle error
        print('Failed to load dry appointments');
      }
    } catch (e) {
      // Handle exceptions
      print('Error loading dry appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredAppointments = [];

    switch (status) {
      case FilterStatus.upcoming:
        filteredAppointments = List<dynamic>.from(upcomingAppointments)
          ..addAll(upcomingDryAppointments);
        break;
      case FilterStatus.complete:
        filteredAppointments = List<dynamic>.from(completeAppointments)
          ..addAll(completeDryAppointments);
        break;
      case FilterStatus.cancel:
        filteredAppointments = List<dynamic>.from(cancelAppointments)
          ..addAll(cancelDryAppointments);
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Appointment Schedule',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (FilterStatus filterStatus in FilterStatus.values)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  status = filterStatus;
                                  if (filterStatus == FilterStatus.upcoming) {
                                    _alignment = Alignment.centerLeft;
                                  } else if (filterStatus ==
                                      FilterStatus.complete) {
                                    _alignment = Alignment.center;
                                  } else if (filterStatus ==
                                      FilterStatus.cancel) {
                                    _alignment = Alignment.centerRight;
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                    filterStatus.toString().split('.').last),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    alignment: _alignment,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status.toString().split('.').last,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: ((context, index) {
                    var appointment = filteredAppointments[index];
                    bool isSlot = appointment is Slot;
                    bool isDry = appointment is Dry;
                    bool isLastElement =
                        index == filteredAppointments.length - 1;

                    return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: !isLastElement
                          ? const EdgeInsets.only(bottom: 20)
                          : EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ScheduleCard(
                              date: isSlot
                                  ? (appointment as Slot).slotDate
                                  : isDry
                                      ? (appointment as Dry).dryDate
                                      : 'N/A',
                              time: isSlot
                                  ? (appointment as Slot).slotTime
                                  : isDry
                                      ? (appointment as Dry).dryTime
                                      : 'N/A',
                              status: isSlot
                                  ? (appointment as Slot).slotStatus
                                  : isDry
                                      ? (appointment as Dry).dryStatus
                                      : 'N/A',
                              isSlot: isSlot,
                              appointmentType: isSlot
                                  ? (appointment as Slot).appointmentTypeWash
                                  : isDry
                                      ? (appointment as Dry).appointmentType
                                      : '',
                            ),
                            if (isSlot &&
                                (appointment as Slot).slotStatus == 'upcoming')
                              ElevatedButton(
                                onPressed: () {
                                  _completeSlotAppointment(appointment as Slot);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                                child: Text(
                                  "Complete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            if (isDry &&
                                (appointment as Dry).dryStatus == 'upcoming')
                              ElevatedButton(
                                onPressed: () {
                                  _completeDryAppointment(appointment as Dry);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Colors.green, // Customize the button color
                                ),
                                child: Text(
                                  "Complete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            if (isSlot &&
                                (appointment as Slot).slotStatus == 'upcoming')
                              ElevatedButton(
                                onPressed: () {
                                  _cancelAppointment(appointment as Slot);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            if ((isSlot &&
                                    (appointment as Slot).slotStatus ==
                                        'cancel') ||
                                (isDry &&
                                    (appointment as Dry).dryStatus == 'cancel'))
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirm Deletion"),
                                            content: Text(
                                                "Are you sure you want to delete this appointment?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (isSlot) {
                                                    deleteAppointment(
                                                        appointment as Slot);
                                                  } else if (isDry) {
                                                    deleteDryAppointment(
                                                        appointment as Dry);
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            if (isDry &&
                                (appointment as Dry).dryStatus == 'upcoming')
                              ElevatedButton(
                                onPressed: () {
                                  _cancelDryAppointment(appointment as Dry);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                child: Align(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeSlotAppointment(Slot appointment) async {
    try {
      final url = Uri.parse('${ServConfig.Serv}php/complete_appointment.php');
      final response = await http.post(
        url,
        body: {
          'slot_id': appointment.slotId,
        },
      );

      if (response.statusCode == 200) {
        // Slot appointment completed successfully, update UI
        setState(() {
          upcomingAppointments.remove(appointment);
          appointment.slotStatus = 'complete';
          completeAppointments.add(appointment);
        });
      } else {
        showErrorDialog(
            "Failed to complete slot appointment. Please try again.");
      }
    } catch (e) {
      showErrorDialog("Network error: Unable to complete slot appointment.");
    }
  }

  void _completeDryAppointment(Dry dryAppointment) async {
    try {
      final url =
          Uri.parse('${ServConfig.Serv}php/complete_dry_appointment.php');
      final response = await http.post(
        url,
        body: {
          'dry_id': dryAppointment.dryId,
        },
      );

      if (response.statusCode == 200) {
        // Dry appointment completed successfully, update UI
        setState(() {
          upcomingDryAppointments.remove(dryAppointment);
          dryAppointment.dryStatus = 'complete';
          completeDryAppointments.add(dryAppointment);
        });
      } else {
        showErrorDialog(
            "Failed to complete dry appointment. Please try again.");
      }
    } catch (e) {
      showErrorDialog("Network error: Unable to complete dry appointment.");
    }
  }

  void deleteAppointment(Slot appointment) async {
    try {
      final response = await http.post(
        Uri.parse('${ServConfig.Serv}php/delete_appointment.php'),
        body: {
          'slot_id': appointment.slotId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            cancelAppointments
                .removeWhere((slot) => slot.slotId == appointment.slotId);
          });
        } else {
          showErrorDialog(data['message']);
        }
      } else {
        showErrorDialog("Failed to delete appointment. Please try again.");
      }
    } catch (e) {
      showErrorDialog("Network error: Unable to delete appointment.");
    }
  }

  void deleteDryAppointment(Dry appointment) async {
    try {
      final response = await http.post(
        Uri.parse('${ServConfig.Serv}php/delete_dry_appointment.php'),
        body: {
          'dry_id': appointment.dryId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            cancelDryAppointments
                .removeWhere((dry) => dry.dryId == appointment.dryId);
          });
        } else {
          showErrorDialog(data['message']);
        }
      } else {
        showErrorDialog("Failed to delete appointment. Please try again.");
      }
    } catch (e) {
      showErrorDialog("Network error: Unable to delete appointment.");
    }
  }

  void _cancelAppointment(Slot appointment) async {
    try {
      final url = Uri.parse('${ServConfig.Serv}php/cancel_appointment.php');
      final response = await http.post(
        url,
        body: {
          'slot_id': appointment.slotId,
        },
      );

      if (response.statusCode == 200) {
        // Appointment canceled successfully, update UI
        setState(() {
          upcomingAppointments.remove(appointment);
          appointment.slotStatus = 'cancel'; // Update the status directly
          cancelAppointments.add(appointment);
        });
      } else {
        showErrorDialog("Failed to cancel appointment. Please try again.");
      }
    } catch (e) {
      showErrorDialog("Network error: Unable to cancel appointment.");
    }
  }

  void _cancelDryAppointment(Dry appointment) async {
    try {
      final url = Uri.parse('${ServConfig.Serv}php/cancel_dry_appointment.php');
      final response = await http.post(
        url,
        body: {
          'dry_id': appointment.dryId,
        },
      );

      if (response.statusCode == 200) {
        // Appointment canceled successfully, update UI
        setState(() {
          upcomingDryAppointments.remove(appointment);
          appointment.dryStatus = 'cancel'; // Update the status directly
          cancelDryAppointments.add(appointment);
        });
      } else {
        showErrorDialog("Failed to cancel appointment. Please try again.");
      }
    } catch (e) {
      showErrorDialog("Network error: Unable to cancel appointment.");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
    required this.date,
    required this.time,
    required this.status,
    required this.isSlot,
    required this.appointmentType,
  }) : super(key: key);

  final String date;
  final String time;
  final String status;
  final bool isSlot;
  final String appointmentType;

  @override
  Widget build(BuildContext context) {
    print(
        'Debug - date: $date, time: $time, status: $status, appointmentType: $appointmentType');
    print('Debug - isSlot: $isSlot');

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 212, 207, 207),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSlot) const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            child: Text(
              '${appointmentType.isNotEmpty ? appointmentType : 'wash'}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            ),
          ),
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBox(
                width: 10,
              ),
              Text(
                '${isSlot ? date : (date ?? 'N/A')}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.timelapse),
              SizedBox(
                width: 10,
              ),
              Text(
                '$time',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.autorenew_outlined),
              SizedBox(
                width: 10,
              ),
              Text(
                '$status',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
