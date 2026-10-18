import 'package:flutter/material.dart';

/// User-defined course model stored in SQLite database
class SubjectModel {
  final int? id;
  final String name; // e.g. Mathematics, Computer Networks
  final int colorValue;
  final String instructor;

  SubjectModel({
    this.id,
    required this.name,
    required this.colorValue,
    this.instructor = '',
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'instructor': instructor,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      colorValue: map['colorValue'] as int,
      instructor: (map['instructor'] as String?) ?? '',
    );
  }
}
