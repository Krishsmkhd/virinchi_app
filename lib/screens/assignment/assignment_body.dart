import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/course.dart';
import 'package:school_management_app/models/student.dart';

import '../../constant/color_const.dart';
import '../../models/assignment.dart';
import 'submit_assignment.dart';

class AssignmentBody extends StatefulWidget {
  final Student student;
  const AssignmentBody({super.key, required this.student});

  @override
  State<AssignmentBody> createState() => _AssignmentBodyState();
}

class _AssignmentBodyState extends State<AssignmentBody> {
  List<Assignment> assignments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getAssignments();
  }

  void getAssignments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('course').where('name', isEqualTo: widget.student.semester).get();

    final Course course = Course.fromQuerySnapshot(querySnapshot.docs.first);
    final List<String> subjects = course.subjects;

    QuerySnapshot assignmentQuerySnapshot = await FirebaseFirestore.instance.collection('assignments').where('subject', whereIn: subjects).get();
    assignments = assignmentQuerySnapshot.docs.map((e) => Assignment.fromFirestore(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(height: 18),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final bool isSubmitted = assignments[index].submissions?.firstWhereOrNull((element) => element.studentId == widget.student.id) != null;

          return ListTile(
            contentPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${assignments[index].subjectName} | ${assignments[index].assignedDate}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Title: ${assignments[index].topicName}'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assignments[index].description),
                SizedBox(height: 10),
                isSubmitted
                    ? Text('Submitted', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                    : Text('Due ${assignments[index].lastSubmissionDate}', style: TextStyle(color: Colors.red)),
              ],
            ),
            trailing: isSubmitted ? Icon(Icons.done, color: Colors.green) : Icon(Icons.arrow_forward_ios),
            onTap: () {
              isSubmitted
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Assignment already submitted')))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubmitAssignment(student: widget.student, assignment: assignments[index])),
                    );
            },
          );
        },
      ),
    );
  }
}
