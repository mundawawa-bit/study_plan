import 'package:flutter/material.dart';

class PlannerModel {
  String id;
  String title;
  String? courseName;
  String notes;
  bool isCompleted;
  DateTime dueDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String plannerType;
  int durationInMinutes;

  PlannerModel({
    required this.id,
    required this.title,
    this.courseName,
    this.notes = '',
    this.isCompleted = false,
    required this.dueDate,
    required this.startTime,
    required this.endTime,
    required this.plannerType,
    this.durationInMinutes = 0,
  });

  // Cek apakah plan sudah lewat waktu / kedaluwarsa
  bool get isExpired {
    final now = DateTime.now();
    final dueDateTime = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      endTime.hour,
      endTime.minute,
    );
    return now.isAfter(dueDateTime);
  }

  // Getter status otomatis untuk badge di card
  String get computedStatus {
    if (isCompleted) return 'Selesai ✨';
    if (isExpired) return 'Plan Terlewat!';
    return 'Belum Selesai';
  }
}