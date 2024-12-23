import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class IndSemesterResultPage extends StatefulWidget {
  final String studentId;
  final String title;
  final List subjects;
  const IndSemesterResultPage({
    super.key,
    required this.subjects,
    required this.title,
    required this.studentId,
  });

  @override
  State<IndSemesterResultPage> createState() => _IndSemesterResultPageState();
}

class _IndSemesterResultPageState extends State<IndSemesterResultPage> {
  bool _loading = true;
  final List<Map<String, dynamic>> subjectMarks = [];
  double gpa = 0.0;

  @override
  void initState() {
    super.initState();
    getMarks();
  }

  Future<void> getMarks() async {
    final db = FirebaseFirestore.instance;
    _loading = true;
    setState(() {});

    try {
      for (final subject in widget.subjects) {
        final querySnapshot = await db.collection('assignments').where('subject', isEqualTo: subject).get();

        if (querySnapshot.docs.isEmpty) continue;

        for (final doc in querySnapshot.docs) {
          final submissions = List<Map<String, dynamic>>.from(doc['submissions'] ?? []);
          final submission = submissions.firstWhere(
            (element) => element['studentId'] == widget.studentId,
            orElse: () => <String, dynamic>{},
          );

          if (submission.isNotEmpty && submission['marks'] != null) {
            subjectMarks.add({
              'subject': subject,
              'marks': submission['marks'],
            });
          }
        }
      }

      gpa = calculateGPA(subjectMarks);
    } catch (e) {
      print('Error fetching marks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: ${e.toString()}')),
      );
    } finally {
      _loading = false;
      setState(() {});
    }
  }

  double calculateGPA(List<Map<String, dynamic>> subjectMarks) {
    double kGPA = 0.0;

    for (final subject in subjectMarks) {
      final marks = int.parse(subject['marks']);

      final gradePoint = _convertMarksToGradePoint(marks);
      kGPA += gradePoint;
    }

    return kGPA / subjectMarks.length;
  }

  double _convertMarksToGradePoint(int marks) {
    if (marks >= 85) return 4.0;
    if (marks >= 80) return 3.7;
    if (marks >= 75) return 3.3;
    if (marks >= 70) return 3.0;
    if (marks >= 65) return 2.7;
    if (marks >= 60) return 2.3;
    if (marks >= 55) return 2.0;
    if (marks >= 50) return 1.7;
    if (marks >= 45) return 1.3;
    if (marks >= 40) return 1.0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SizedBox(height: 20),
                ListTile(
                  tileColor: Colors.grey.shade400,
                  title: const Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: const Text('Grade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.subjects.length,
                  itemBuilder: (context, index) {
                    final marks = subjectMarks.firstWhereOrNull((element) {
                      return element['subject'] == widget.subjects[index];
                    })?['marks'];
                    return ListTile(
                      title: Text(widget.subjects[index]),
                      trailing: Text(marks ?? 'N/A', style: TextStyle(fontSize: 16)),
                    );
                  },
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('GPA: ${gpa.toString()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))))
              ],
            ),
    );
  }
}
