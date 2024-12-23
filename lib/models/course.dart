import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final int index;
  final String name;
  final List<String> subjects;

  const Course({
    required this.index,
    required this.name,
    required this.subjects,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      index: json['index'] as int,
      name: json['name'] as String,
      subjects: (json['sub'] as List).map((e) => e as String).toList(),
    );
  }

  factory Course.fromQuerySnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    return Course(
      index: snapshot['index'] as int,
      name: snapshot['name'] as String,
      subjects: (snapshot['sub'] as List).map((e) => e as String).toList(),
    );
  }
}
