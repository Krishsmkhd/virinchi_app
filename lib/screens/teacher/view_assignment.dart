import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/teacher.dart';
import 'package:school_management_app/screens/teacher/assignment_details.dart';
import 'package:school_management_app/screens/teacher/give_assignment.dart';

import '../../constant/color_const.dart';
import '../../models/assignment.dart';

class ViewAssignment extends StatefulWidget {
  final Teacher teacher;
  const ViewAssignment({super.key, required this.teacher});

  @override
  State<ViewAssignment> createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {
  List<Assignment> assignments = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getAssignments();
  }

  void getAssignments() async {
    final List<Assignment> res = [];

    loading = true;
    await FirebaseFirestore.instance.collection("assignments").where('subject', isEqualTo: widget.teacher.subject).get().then((value) {
      value.docs.map((e) => res.add(Assignment.fromFirestore(e))).toList();
    });

    assignments = res;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => GiveAssignment(teacher: widget.teacher)));
          getAssignments();
        },
        backgroundColor: AppColor.primary,
        label: Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            Text('Add Assignment', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('View Assignment'),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(height: 18),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assignments[index].assignedDate, style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Title: ${assignments[index].topicName}'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assignments[index].description),
                SizedBox(height: 10),
                Text('Due ${assignments[index].lastSubmissionDate}', style: TextStyle(color: Colors.red)),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssignmentDetails(assignment: assignments[index])),
              );
              getAssignments();
            },
          );
        },
      ),
    );
  }
}
