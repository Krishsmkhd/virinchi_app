import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/student.dart';

import 'ind_semester_result_page.dart';

class ResultPage extends StatefulWidget {
  final Student student;
  const ResultPage({super.key, required this.student});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _loading = true;
  List subjects = [];

  void getSubject() async {
    final db = FirebaseFirestore.instance;
    final data = await db.collection('course').get();
    subjects = data.docs.map((e) => e.data()).toList();
    subjects.sort((a, b) => (a['index'] as int) - (b['index'] as int));
    _loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Result'),
            const SizedBox(height: 40),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Credits earned: ${int.parse(widget.student.semester.split(" (").first.split(" ").last) * 20}/160',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: subjects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final isCurrent =
                    widget.student.semester == subjects[index]['name'];
                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndSemesterResultPage(
                        studentId: widget.student.id,
                        title: subjects[index]['name'] as String,
                        subjects: subjects[index]['sub'] as List,
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                  tileColor: isCurrent ? AppColor.primary : Colors.white,
                  textColor: isCurrent ? Colors.white : Colors.black,
                  iconColor: isCurrent ? Colors.white : Colors.black,
                  title: Text(
                    subjects[index]['name'] as String,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
    );
  }
}
