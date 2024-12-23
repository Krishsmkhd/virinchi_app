import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/screens/Admin/edit_view_teacher.dart';
import '../../models/teacher.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  _TeacherListScreenState createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  List<Teacher> allTeachers = [];
  List<Teacher> teachers = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getTeachers();
  }

  void getTeachers() async {
    loading = true;
    allTeachers.clear();
    teachers.clear();
    await FirebaseFirestore.instance.collection("teachers").get().then((value) {
      value.docs.map((e) => teachers.add(Teacher.fromFirestore(e))).toList();
    });
    allTeachers = teachers;
    setState(() => loading = false);
  }

  void filterTeacher(String text) {
    if (text.isEmpty) {
      teachers = allTeachers;
      setState(() {});
      return;
    }
    teachers =
        allTeachers.where((e) => e.name.toLowerCase().contains(text)).toList();
    setState(() {});
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
          : Column(
              children: [
                SizedBox(height: 12),
                SearchBar(onChanged: filterTeacher, hintText: "Search Teacher"),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Teacher teacher = teachers[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(teacher.imageUrl),
                          ),
                          title: Text(teacher.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${teacher.email}'),
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
                                          EditViewTeacher(teacher: teacher),
                                    ),
                                  ).then((_) => getTeachers());
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // delete the selected teacher from firestore
                                  // Get a reference to the document that you want to delete
                                  var documentRef = FirebaseFirestore.instance
                                      .collection('teachers')
                                      .doc(teacher.id);
                                  documentRef
                                      .delete()
                                      .then((value) => setState(() {
                                            teachers.removeAt(index);
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
