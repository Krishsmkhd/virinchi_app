import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/screens/admin/edit_view_student.dart';
import 'package:school_management_app/utils/utils.dart';
import '../../models/student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> allStudents = [];
  List<Student> students = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getStudents();
  }

  void getStudents() async {
    loading = true;
    allStudents.clear();
    students.clear();
    await FirebaseFirestore.instance.collection("students").get().then((value) {
      value.docs.map((e) => students.add(Student.fromFirestore(e))).toList();
    });
    allStudents = students;
    setState(() => loading = false);
  }

  void filterStudent(String text) {
    if (text.isEmpty) {
      students = allStudents;
      setState(() {});
      return;
    }
    students =
        allStudents.where((e) => e.name.toLowerCase().contains(text)).toList();
    setState(() {});
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
          : Column(
              children: [
                SizedBox(height: 12),
                SearchBar(onChanged: filterStudent, hintText: "Search Student"),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewEditStudentScreen(
                                              student: student),
                                    ),
                                  ).then((_) => getStudents());
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final delete =
                                      await Utils.showDeleteConfirmationDialog(
                                          context);
                                  if (delete == null || !delete) return;
                                  // delete the selected student from firestore
                                  // Get a reference to the document that you want to delete
                                  var documentRef = FirebaseFirestore.instance
                                      .collection('students')
                                      .doc(student.id);
                                  documentRef
                                      .delete()
                                      .then((value) => setState(() {
                                            students.removeAt(index);
                                          }))
                                      .catchError((error) => debugPrint(
                                          "Failed to delete document: $error"));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class TextFieldPopup extends StatelessWidget {
  const TextFieldPopup(
      {super.key, required this.nameController, required this.labelText});

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
