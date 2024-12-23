// To parse this JSON data, do
//
//     final studentInfo = studentInfoFromJson(jsonString);

import 'dart:convert';

List<StudentInfo> studentInfoFromJson(String str) =>
    List<StudentInfo>.from(json.decode(str));

String studentInfoToJson(StudentInfo data) => json.encode(data.toJson());

class StudentInfo {
  StudentInfo({
    required this.studentId,
    required this.studentUserName,
    this.studentStatus,
    required this.studentName,
    required this.studentClass,
    this.studentBirthdate,
    required this.studentRollNo,
    this.studentAddress,
    required this.studentPhone,
    required this.studentEmail,
    this.studentPhoto,
  });

  String studentId;
  String studentUserName;
  String? studentStatus;
  String studentName;
  int studentClass;
  DateTime? studentBirthdate;
  String studentRollNo;
  String? studentAddress;
  String studentPhone;
  String studentEmail;
  String? studentPhoto;

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
        studentId: json["student_id"],
        studentUserName: json["student_user_name"],
        studentStatus: json["student_status"],
        studentName: json["student_name"],
        studentClass: json["student_class"],
        studentBirthdate: DateTime.parse(json["student_birthdate"]),
        studentRollNo: json["student_roll"],
        studentAddress: json["student_address"],
        studentPhone: json["student_phone"],
        studentEmail: json["student_email"],
        studentPhoto: json["student_photo"],
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "student_user_name": studentUserName,
        "student_status": studentStatus,
        "student_name": studentName,
        "student_class": studentClass,
        "student_birthdate":
            "${studentBirthdate!.year.toString().padLeft(4, '0')}-${studentBirthdate!.month.toString().padLeft(2, '0')}-${studentBirthdate!.day.toString().padLeft(2, '0')}",
        "student_roll_no": studentRollNo,
        "student_address": studentAddress,
        "student_phone": studentPhone,
        "student_email": studentEmail,
        "student_photo": studentPhoto,
      };
}
