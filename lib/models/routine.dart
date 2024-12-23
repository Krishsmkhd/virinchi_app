import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Routine {
  final int class_;
  final String section;
  final String day;
  final List<Subject> subjects;
  const Routine({
    required this.class_,
    required this.section,
    required this.day,
    required this.subjects,
  });

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      class_: map['class'],
      section: map['section'],
      day: map['day'],
      subjects: List<Subject>.from(
          map['subjects']?.map((x) => Subject.fromMap(x)) ?? const []),
    );
  }
}

class Subject {
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Subject({
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      name: map['name'],
      startTime: toTimeOfDay(map['startTime']),
      endTime: toTimeOfDay(map['endTime']),
    );
  }

  static TimeOfDay toTimeOfDay(String timeString) {
    final format = DateFormat.jm(); // Format to use
    final time = format.parse(timeString); // Parse the time
    final timeOfDay = TimeOfDay.fromDateTime(time); // Convert to TimeOfDay

    return timeOfDay;
  }
}
