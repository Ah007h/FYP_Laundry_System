import 'user.dart';

class Dry {
  final String dryId;
  final User user;
  final String dryTime;
  String dryStatus;
  final String dryDate;
  final String appointmentType;

  Dry({
    required this.dryId,
    required this.user,
    required this.dryTime,
    required this.dryStatus,
    required this.dryDate,
    required this.appointmentType,
  });

  factory Dry.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError("Received null JSON data for Dry");
    }

    final dryId = json['dry_id'];
    final dryTime = json['dry_time'];
    final dryStatus = json['dry_status'];
    final dryDate = json['dry_date'];
    final appointmentType = json['appointment_type'];

    final userJson = json['user'];
    User user;

    if (userJson != null) {
      user = User.fromJson(userJson);
    } else {
      user = User(id: '', name: '', email: '', phone: '', regdate: '');
    }

    return Dry(
      dryId: dryId ?? '',
      user: user,
      dryTime: dryTime ?? '',
      dryStatus: dryStatus ?? '',
      dryDate: dryDate ?? '',
      appointmentType: appointmentType ?? 'dry', // Provide a default value or handle accordingly
    );
  }
}