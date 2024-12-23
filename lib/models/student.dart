import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String matrixNumber;
  final String name;
  final String semester;
  final String section;
  final String email;
  final String address;
  final String dob;
  final String imageUrl;
  final String password;

  Student({
    required this.id,
    required this.name,
    required this.section,
    required this.email,
    required this.address,
    required this.dob,
    required this.imageUrl,
    required this.matrixNumber,
    required this.semester,
    required this.password,
  });

  factory Student.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Student(
      id: doc.id,
      name: data['name'],
      dob: data['dob'],
      email: data['email'],
      address: data['address'],
      section: data['section'],
      imageUrl: data['imageUrl'] ??
          "https://st3.depositphotos.com/1767687/16607/v/600/depositphotos_166074422-stock-illustration-default-avatar-profile-icon-grey.jpg",
      matrixNumber: data['matrixNumber'],
      semester: data['semester'],
      password: data['password'],
    );
  }

  factory Student.fromMap(Map data, String id) {
    return Student(
      id: id,
      name: data['name'],
      dob: data['dob'],
      email: data['email'],
      address: data['address'],
      semester: data['semester'],
      section: data['section'],
      imageUrl: data['imageUrl'] ??
          "https://st3.depositphotos.com/1767687/16607/v/600/depositphotos_166074422-stock-illustration-default-avatar-profile-icon-grey.jpg",
      matrixNumber: data['matrixNumber'],
      password: data['password'],
    );
  }
}
