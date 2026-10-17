import 'package:flutter/material.dart';

/// Data model representing a university course / subject
class CourseModel {
  final String id;
  final String code;
  final String title;
  final String instructor;
  final String room;
  final String scheduleTime;
  final Color backgroundColor;
  final Color borderColor;

  CourseModel({
    required this.id,
    required this.code,
    required this.title,
    required this.instructor,
    required this.room,
    required this.scheduleTime,
    required this.backgroundColor,
    required this.borderColor,
  });
}
