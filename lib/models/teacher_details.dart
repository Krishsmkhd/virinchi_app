// To parse this JSON data, do
//
//     final studentInfo = studentInfoFromJson(jsonString);

import 'dart:convert';

StudentInfo studentInfoFromJson(String str) =>
    StudentInfo.fromJson(json.decode(str));

String studentInfoToJson(StudentInfo data) => json.encode(data.toJson());

class StudentInfo {
  StudentInfo({
    required this.teacherId,
    required this.schoolId,
    required this.teacherName,
    this.gender,
    this.maritalstatus,
    this.teacherBirthdate,
    this.teacherDetail,
    this.teacherImage,
    required this.teacherPhone,
    required this.teacherEmail,
    this.teacherEducation,
    required this.teacherAddress,
    this.teacherExp,
    this.teacherNotes,
    this.onDate,
  });

  String teacherId;
  String schoolId;
  String teacherName;
  String? gender;
  String? maritalstatus;
  DateTime? teacherBirthdate;
  String? teacherDetail;
  String? teacherImage;
  String teacherPhone;
  String teacherEmail;
  String? teacherEducation;
  String teacherAddress;
  String? teacherExp;
  String? teacherNotes;
  DateTime? onDate;

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
        teacherId: json["teacher_id"],
        schoolId: json["school_id"],
        teacherName: json["teacher_name"],
        gender: json["gender"],
        maritalstatus: json["maritalstatus"],
        teacherBirthdate: DateTime.parse(json["teacher_birthdate"]),
        teacherDetail: json["teacher_detail"],
        teacherImage: json["teacher_image"],
        teacherPhone: json["teacher_phone"],
        teacherEmail: json["teacher_email"],
        teacherEducation: json["teacher_education"],
        teacherAddress: json["teacher_address"],
        teacherExp: json["teacher_exp"],
        teacherNotes: json["teacher_notes"],
        onDate: DateTime.parse(json["on_date"]),
      );

  Map<String, dynamic> toJson() => {
        "teacher_id": teacherId,
        "school_id": schoolId,
        "teacher_name": teacherName,
        "gender": gender,
        "maritalstatus": maritalstatus,
        "teacher_birthdate":
            "${teacherBirthdate!.year.toString().padLeft(4, '0')}-${teacherBirthdate!.month.toString().padLeft(2, '0')}-${teacherBirthdate!.day.toString().padLeft(2, '0')}",
        "teacher_detail": teacherDetail,
        "teacher_image": teacherImage,
        "teacher_phone": teacherPhone,
        "teacher_email": teacherEmail,
        "teacher_education": teacherEducation,
        "teacher_address": teacherAddress,
        "teacher_exp": teacherExp,
        "teacher_notes": teacherNotes,
        "on_date": onDate!.toIso8601String(),
      };
}
