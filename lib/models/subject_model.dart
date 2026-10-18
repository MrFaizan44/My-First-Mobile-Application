import 'package:flutter/material.dart';

/// User-defined subject model stored in SQLite database
class SubjectModel {
  final int? id;
  final String name;
  final String code;
  final int colorValue;
  final String instructor;
  final String location;

  SubjectModel({
    this.id,
    required this.name,
    required this.code,
    required this.colorValue,
    this.instructor = '',
    this.location = '',
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'colorValue': colorValue,
      'instructor': instructor,
      'location': location,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      code: map['code'] as String,
      colorValue: map['colorValue'] as int,
      instructor: (map['instructor'] as String?) ?? '',
      location: (map['location'] as String?) ?? '',
    );
  }
}
