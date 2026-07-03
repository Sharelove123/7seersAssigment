import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final bool isFirstTime;
  final bool completedCheckIn;
  final DateTime? lastCheckInDate;

  UserModel({
    required this.id,
    required this.name,
    required this.isFirstTime,
    required this.completedCheckIn,
    this.lastCheckInDate,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      isFirstTime: map['isFirstTime'] ?? false,
      completedCheckIn: map['completedCheckIn'] ?? false,
      lastCheckInDate: (map['lastCheckInDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isFirstTime': isFirstTime,
      'completedCheckIn': completedCheckIn,
      'lastCheckInDate': lastCheckInDate != null
          ? Timestamp.fromDate(lastCheckInDate!)
          : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    bool? isFirstTime,
    bool? completedCheckIn,
    DateTime? lastCheckInDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      completedCheckIn: completedCheckIn ?? this.completedCheckIn,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
    );
  }
}
