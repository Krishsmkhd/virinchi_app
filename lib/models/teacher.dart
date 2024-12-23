import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String imageUrl;
  final String dob;
  final String password;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.imageUrl,
    required this.dob,
    required this.password,
  });

  factory Teacher.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Teacher(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      subject: data['subject'],
      imageUrl: data['imageUrl'],
      dob: data['dob'],
      password: data['password'],
    );
  }

  factory Teacher.fromMap(Map data, String id) {
    return Teacher(
      id: id,
      name: data['name'],
      email: data['email'],
      subject: data['subject'],
      imageUrl: data['imageUrl'],
      dob: data['dob'],
      password: data['password'],
    );
  }
}
