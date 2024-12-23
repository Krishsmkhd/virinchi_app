import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/teacher.dart';

class ViewTeachers extends StatefulWidget {
  const ViewTeachers({super.key});

  @override
  _ViewTeachersState createState() => _ViewTeachersState();
}

class _ViewTeachersState extends State<ViewTeachers> {
  List<Teacher> teachers = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getStudents();
  }

  void getStudents() async {
    loading = true;
    await FirebaseFirestore.instance.collection("teachers").where('course', isEqualTo: 'BICT').get().then((value) {
      value.docs.map((e) => teachers.add(Teacher.fromFirestore(e))).toList();
    });
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher List'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (BuildContext context, int index) {
                final Teacher student = teachers[index];
                return Card(
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${student.email}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class TextFieldPopup extends StatelessWidget {
  const TextFieldPopup({super.key, required this.nameController, required this.labelText});

  final TextEditingController nameController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(labelText: labelText),
      ),
    );
  }
}
