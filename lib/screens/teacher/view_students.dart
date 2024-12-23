import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/student.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({super.key});

  @override
  _ViewStudentsState createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  List<Student> students = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getStudents();
  }

  void getStudents() async {
    loading = true;
    await FirebaseFirestore.instance.collection("students").where('course', isEqualTo: 'BICT').get().then((value) {
      value.docs.map((e) => students.add(Student.fromFirestore(e))).toList();
    });
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                final Student student = students[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(student.imageUrl),
                    ),
                    title: Text(student.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Semester: ${student.semester}'),
                        Text('Section: ${student.section}'),
                        Text('Email: ${student.email}'),
                        Text('Address: ${student.address}'),
                        Text('Date of Birth: ${student.dob}'),
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
