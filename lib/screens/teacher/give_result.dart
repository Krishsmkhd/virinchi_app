import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/color_const.dart';
import '../../models/student.dart';

class GiveResult extends StatefulWidget {
  const GiveResult({super.key});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<GiveResult> {
  late String _selectedSubject = "Math";
  late String marks = "";
  List<Student> students = [];
  bool loading = false;
  bool isFormVisible = false;
  String id = '';
  final List<String> _subjects = [
    'Science',
    'Math',
    'English',
    'History',
    'Geography',
    'Art'
  ];

  @override
  void initState() {
    super.initState();
    getStudent();
  }

  getStudent() async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance.collection("students").get().then((value) {
      value.docs.map((e) => students.add(Student.fromFirestore(e))).toList();
    });
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Results'),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: null,
                decoration: const InputDecoration(labelText: 'Student'),
                items: students
                    .map((student) => DropdownMenuItem(
                        value: student.id, child: Text(student.name)))
                    .toList(),
                onChanged: (value) => setState(() {
                  isFormVisible = true;
                  id = value.toString();
                }),
                validator: (value) =>
                    value == null ? 'Student is required' : null,
              ),
              Visibility(
                visible: isFormVisible,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text('Subject'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _subjects.first,
                      onChanged: (value) =>
                          setState(() => _selectedSubject = value!),
                      items: _subjects.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Marks'),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) => setState(() => marks = value),
                      decoration: const InputDecoration(
                        hintText: 'Enter marks',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: AppColor
                              .primary, // change the button's background color here
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("students")
                              .doc(id)
                              .collection("results")
                              .add({
                            "subject": _selectedSubject,
                            "marks": marks,
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Result added')));
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String to12hrFromDateTime(DateTime dateTime) {
  return DateFormat('h:mm a').format(dateTime);
}

String to12hr(TimeOfDay dateTime) {
  return DateFormat('h:mm a').format(
    DateTime(0, 0, 0, dateTime.hour, dateTime.minute),
  );
}
