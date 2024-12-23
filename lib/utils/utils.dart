import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management_app/models/assignment.dart';
import 'package:school_management_app/models/course.dart';

class Utils {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: '717514981826382',
    apiSecret: 'Bd8sACwkH65dV8s3fewZl4tmgQ0',
    cloudName: 'dcyfbxh4a',
  );
  static final imagePicker = ImagePicker();

  static Future<String?> uploadImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final response = await cloudinary.upload(file: pickedFile.path);
    return response.secureUrl;
  }

  static Future<String?> uploadSingleImage(String filePath) async {
    final response = await cloudinary.upload(file: filePath);
    return response.secureUrl;
  }

  static Future<List<Attachment>> uploadFiles(List<Attachment> files) async {
    final List<Attachment> urls = [];
    for (final file in files) {
      final response = await cloudinary.upload(file: file.url);
      urls.add(Attachment(name: file.name, url: response.secureUrl));
    }
    return urls;
  }

  static Future<List<String>> getSubject() async {
    final List<String> subjects = [];
    final List<Course> courses;

    final db = FirebaseFirestore.instance;
    final data = await db.collection('course').get();
    courses = data.docs.map((e) => Course.fromJson(e.data())).toList();
    courses.sort((a, b) => a.index - b.index);

    for (final course in courses) {
      for (final element in course.subjects) {
        subjects.add(element);
      }
    }
    return subjects;
  }

  static Future<List<Course>> getSemester() async {
    final List<Course> courses = [];

    final db = FirebaseFirestore.instance;
    final data = await db.collection('course').get();
    courses.addAll(data.docs.map((e) => Course.fromJson(e.data())).toList());
    courses.sort((a, b) => a.index - b.index);

    return courses;
  }

  static Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete?'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                foregroundColor: WidgetStateProperty.all(Colors.black),
                fixedSize: WidgetStateProperty.all(Size(100, 30)),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                fixedSize: WidgetStateProperty.all(Size(100, 30)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to logout?'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                foregroundColor: WidgetStateProperty.all(Colors.black),
                fixedSize: WidgetStateProperty.all(Size(100, 30)),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                fixedSize: WidgetStateProperty.all(Size(100, 30)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
