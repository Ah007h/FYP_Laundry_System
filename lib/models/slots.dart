import 'user.dart';

class Slot {
  final String? slotId;
  final User user;
  final String slotTime;
  String slotStatus;
  final String slotDate;
  final String appointmentTypeWash;

  Slot({
    required this.user,
    required this.slotTime,
    required this.slotStatus,
    required this.slotDate,
    required this.appointmentTypeWash,
    this.slotId,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError("Received null JSON data for Slot");
    }

    final slotId = json['slot_id'] as String?;
    final slotTime = json['slot_time'] as String? ?? ''; // Null check and provide a default value
   final slotStatus = json['slot_status'] as String? ?? 'Default Status';
    final slotDate = json['slot_date'] as String? ?? 'Default Date';

    final appointmentTypeWash = json['appointment_type_wash'] as String? ?? '';

    // You may need to adapt this part based on the structure of the 'user' data in your JSON
    final userJson = json['user'];
    User user;

    if (userJson != null) {
      user = User.fromJson(userJson);
    } else {
      user = User(id: '', name: '', email: '', phone: '', regdate: '');
    }

    return Slot(
      user: user,
      slotTime: slotTime,
      slotStatus: slotStatus,
      slotDate: slotDate,
      appointmentTypeWash: appointmentTypeWash,
      slotId: slotId,
    );
  }
}
