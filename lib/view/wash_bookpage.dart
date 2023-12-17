import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/models/user.dart';
import 'package:project_fyp/shared/config.dart';
import 'package:project_fyp/view/success_booked.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class WashBookPage extends StatefulWidget {
  final Slot slot;
  final User user;
  final Dry dry;
  const WashBookPage({Key? key, required this.slot, required this.user, required this.dry})
      : super(key: key);

  @override
  State<WashBookPage> createState() => _WashBookPageState();
}

class _WashBookPageState extends State<WashBookPage> {
  DateTime today = DateTime.now();
  int? _selectedTimeIndex;
  DateTime? _selectedDay;
  List<Map<String, dynamic>> bookedSlots = [];
  List<Map<String, dynamic>> bookedSlotsByCurrentUser = [];
  bool isLoading = false;
  bool isFirstTimeAppointmentPage = true;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  String? selectedYearMonth = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _selectedTimeIndex = null; // Set _selectedTimeIndex to null initially
    fetchBookedSlots();
  }

  Future<void> fetchBookedSlots() async {
  setState(() => isLoading = true);
  try {
    final response = await http.get(Uri.parse('${ServConfig.Serv}php/get_booked_slots.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      bookedSlots = data
          .map<Map<String, dynamic>>(
              (slot) => Map<String, dynamic>.from(slot))
          .toList();

      // Filter slots booked by the current user
      bookedSlotsByCurrentUser = bookedSlots
          .where((slot) => slot['user_id'] == widget.user.id)
          .toList();

      setState(() => isLoading = false);
    } else {
      showErrorDialog("Error fetching slots: Server responded with status code ${response.statusCode}");
    }
  } catch (e) {
    showErrorDialog("Network error: Unable to fetch booked slots.");
  } finally {
    setState(() => isLoading = false);
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

  CalendarStyle _calendarStyle = CalendarStyle(
    selectedDecoration: BoxDecoration(
      color: Colors.blue, // Change this color to the desired selected day color
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(16.0),
    ),
  );

  String getFormattedTime() {
    if (_selectedTimeIndex == null) return "No time selected";
    final int startHour = _selectedTimeIndex! ~/ 2;
    final int startMinute = (_selectedTimeIndex! % 2) * 30;
    final int endHour = (startMinute == 30) ? (startHour + 1) % 24 : startHour;
    final int endMinute = (startMinute + 30) % 60;
    return '${formatTime(startHour, startMinute)}-${formatTime(endHour, endMinute)}';
  }

  bool isSlotBooked(
    DateTime selectedDate,
    String selectedTime,
    String? userId,
  ) {
    String selectedDateString = formatDate(selectedDate);

    // Split the multiline selectedTime into start and end times
    final List<String> selectedTimes =
        selectedTime.split('\n'); // Use '\n' as the separator
    if (selectedTimes.length != 2) {
      // Check if there are exactly two parts (start and end times)
      return false;
    }

    final String selectedStartTime = selectedTimes[0].trim();
    final String selectedEndTime = selectedTimes[1].trim();

    for (var slot in bookedSlots) {
      if (slot['slot_date'] == selectedDateString &&
          slot['slot_time'].startsWith(selectedStartTime) &&
          slot['slot_time'].endsWith(selectedEndTime) &&
          slot['user_id'] == userId) {
        return true;
      }
    }
    return false;
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _selectedDay = day;
      today = day;
      if (isFirstTimeAppointmentPage) {
        _selectedTimeIndex = null;
        isFirstTimeAppointmentPage = false;
      }
    });
  }

  void _selectTime(int index) {
    final selectedSlot = getFormattedTime();
    final isSlotAlreadyBooked =
        isSlotBooked(today, selectedSlot, widget.user.id);

    if (!isSlotAlreadyBooked) {
      setState(() {
        _selectedTimeIndex = index;
      });
    } else {
      showErrorDialog(
          "The selected slot is already booked by you. Please choose another slot.");
    }
  }

  String formatTime(int hour, int minute) {
    final String formattedHour = hour == 0
        ? "12"
        : (hour <= 12 ? hour.toString() : (hour - 12).toString());
    final String amPm = hour < 12 ? "AM" : "PM";
    return '$formattedHour:${minute.toString().padLeft(2, '0')} $amPm';
  }

 void _bookAppointment() async {
    final selectedSlot = getFormattedTime();
    final isSlotAlreadyBooked =
        isSlotBooked(today, selectedSlot, widget.user.id);

    if (!isSlotAlreadyBooked) {
      final url = Uri.parse('${ServConfig.Serv}php/book_appointment.php');
      final response = await http.post(
        url,
        body: {
          'date': today.toLocal().toString(),
          'time': selectedSlot,
          'status': 'upcoming',
          'user_id': widget.user.id,
          'appointment_type_wash': 'wash',  // Change the field name
        },
      );

      if (response.statusCode == 200) {
        final slotData = json.decode(response.body);
        final slot = Slot.fromJson({
          ...slotData,
          'appointment_type_wash': 'wash', // Change the field name
        });
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(user: widget.user, slot: slot, dry: widget.dry,),
          ),
        );

        fetchBookedSlots();
      } else {
        showErrorDialog("Failed to book appointment. Please try again.");
      }
    } else {
      showErrorDialog(
          "The selected slot is already booked by you. Please choose another slot.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 100, 153, 222),
                      Color.fromARGB(255, 58, 81, 124),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  // Wrap your content in a Stack
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 13,top: 14),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,size: 47,),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 200,
                          margin: EdgeInsets.only(
                              left: 300), // Adjust margin as needed
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                'assets/images/L.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        _buildCalendarRow(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildConsultationTimeCard(_selectedTimeIndex),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: _bookAppointment,
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 180, 205, 225), // Background color
                              onPrimary:
                                  Color.fromARGB(255, 5, 91, 161), // Text color
                              elevation: 5, // Elevation (shadow)
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Button border radius
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 24),
                              child: Text(
                                "BOOK",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 630), // Adjust the top margin as needed
                        child: Text(
                          "Wash Booking",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      today = DateTime(today.year, today.month - 1, today.day);
    });
  }

  void _goToNextMonth() {
    setState(() {
      today = DateTime(today.year, today.month + 1, today.day);
    });
  }

  Widget _buildCalendarRow() {
    final formattedMonth = DateFormat('MMMM yyyy').format(today);

    return Container(
      margin: EdgeInsets.only(
         left: 7, right: 7, bottom: 5
      ),
      padding: EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Shadow color
            offset: Offset(4, 4), // Offset of the shadow
            blurRadius: 20, // Spread of the shadow
            spreadRadius: 0, // Spread radius
          ),
        ],
      ), // Set the desired background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _goToPreviousMonth,
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    "<",
                    style: TextStyle(fontSize: 28, color: Colors.blue),
                  ),
                ),
              ),
              Text(
                formattedMonth,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _goToNextMonth,
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Text(
                    ">",
                    style: TextStyle(fontSize: 28, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                final day = today.add(Duration(days: index - 3));
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _buildDayCard(day),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Static constant for total daily slots
  static const int totalDailySlots = 48;

  int getSlotsForDay(DateTime day) {
    // Format the day to match the slot_date format in bookedSlots
    String formattedDate = DateFormat('yyyy-MM-dd').format(day);

    // Count the number of slots booked for this day
    int bookedCount =
        bookedSlots.where((slot) => slot['slot_date'] == formattedDate).length;

    // Calculate the number of available slots
    int availableSlots = totalDailySlots - bookedCount;

    return availableSlots;
  }

  Widget _buildDayCard(DateTime day) {
    final isToday = isSameDay(day, DateTime.now());
    final isSelected = _selectedDay != null &&
        isSameDay(day, _selectedDay); // Check if the day is selected

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Add a border here
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Card(
        elevation: isToday ? 4 : 0,
        color: isSelected
            ? Color.fromARGB(157, 84, 176, 252)
            : Color.fromARGB(255, 247, 247, 247),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isToday
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            width: 3,
          ),
        ),
        child: InkWell(
          onTap: () => _onDaySelected(day, today),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(day),
                  style: TextStyle(
                    color: isToday
                        ? const Color.fromARGB(255, 15, 14, 14)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('d').format(day),
                  style: TextStyle(
                    color: isToday
                        ? const Color.fromARGB(255, 6, 5, 5)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationTimeCard(int? selectedTimeIndex) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(left: 7, right: 6,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 49),
            child: ListTile(
              title: Text(
                'Select Consultation Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 49),
            child: Row(
              children: [
                _buildLegendCircle(Colors.grey, 'Booked'),
                SizedBox(width: 10),
                _buildLegendCircle(Colors.yellow, 'Crowded'),
                SizedBox(width: 10),
                _buildLegendCircle(Colors.red, 'Overcrowded'),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 320,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.6,
              ),
              itemCount: 48,
              itemBuilder: (context, index) {
                final int startHour = index ~/ 2;
                final int startMinute = (index % 2) * 30;
                final int endHour =
                    (startMinute == 30) ? (startHour + 1) % 24 : startHour;
                final int endMinute = (startMinute + 30) % 60;
                final slot =
                    '${formatTime(startHour, startMinute)}-\n${formatTime(endHour, endMinute)}';
                final isSlotAlreadyBooked =
                    isSlotBooked(today, slot, widget.user.id);
                final bool isSelected = selectedTimeIndex == index;

                // Calculate the number of users booked at the same time
                int usersBookedAtSameTime = getUsersBookedAtSameTime(slot);

                return isSlotAlreadyBooked
                    ? _buildBookedSlot(slot)
                    : _buildAvailableSlot(
                        slot, isSelected, index, usersBookedAtSameTime);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCircle(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  Widget _buildAvailableSlot(
      String slot, bool isSelected, int index, int usersBookedAtSameTime) {
    final isSlotAlreadyBooked = isSlotBooked(today, slot, widget.user.id);

    Color getIndicatorColor(int usersBooked) {
      if (usersBooked >= 8) {
        return Colors.red;
      } else if (usersBooked >= 5) {
        return Colors.yellow;
      } else {
        return Color.fromARGB(105, 255, 254, 254);
      }
    }

    // Split the slot text into start and end times
    final List<String> times = slot.split('-');
    final String startTime = times[0].trim();
    final String endTime = times[1].trim();

    return InkWell(
      onTap: () {
        if (!isSlotAlreadyBooked) {
          _selectTime(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 17, right: 14, bottom: 7, ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSlotAlreadyBooked
                ? Colors.grey
                : (isSelected ? Color.fromARGB(255, 1, 89, 160) : Colors.black),
          ),
          borderRadius: BorderRadius.circular(15),
          color: getIndicatorColor(
            usersBookedAtSameTime,
          ), // Use usersBookedAtSameTime here
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              startTime, // Display the start time
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSlotAlreadyBooked
                    ? Colors.white
                    : (isSelected
                        ? Color.fromARGB(255, 16, 16, 253)
                        : Colors.black),
              ),
            ),
            SizedBox(height: 5),
            Text(
              '-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSlotAlreadyBooked
                    ? Colors.white
                    : (isSelected
                        ? Color.fromARGB(255, 16, 16, 253)
                        : Colors.black),
              ),
            ),
            SizedBox(height: 5),
            Text(
              endTime, // Display the end time
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSlotAlreadyBooked
                    ? Colors.white
                    : (isSelected
                        ? Color.fromARGB(255, 16, 16, 253)
                        : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookedSlot(String slot) {
    // Split the slot text into start and end times
    final List<String> times = slot.split('-');
    final String startTime = times[0].trim();
    final String endTime = times[1].trim();

    return Container(
      margin: const EdgeInsets.only(left: 17, right: 14, bottom: 7, ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            startTime, // Display the start time
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '-',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            endTime, // Display the end time
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  int getUsersBookedAtSameTime(String slot) {
    // Format the current day
    String formattedDate = formatDate(today);

    // Split the slot text into start and end times
    final List<String> times =
        slot.split('-\n'); // Adjusted to match the format
    if (times.length != 2) {
      return 0; // Return 0 if the format is incorrect
    }
    final String startTime = times[0].trim();
    final String endTime = times[1].trim();

    // Count the number of users booked at the same time
    return bookedSlots
        .where((slotData) =>
            slotData['slot_date'] == formattedDate &&
            slotData['slot_time'].startsWith(startTime) &&
            slotData['slot_time'].endsWith(endTime))
        .length;
  }

  String formatDate(DateTime date) {
    // Implement this method to match your date format used in the database
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
