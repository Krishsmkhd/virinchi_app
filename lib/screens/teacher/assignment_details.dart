import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/assignment.dart';
import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/utils/utils.dart';

import '../../models/course.dart';

class AssignmentDetails extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetails({super.key, required this.assignment});

  @override
  State<AssignmentDetails> createState() => _AssignmentDetailsState();
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  List<Student> _students = [];
  String? semester;

  Future<void> getStudents() async {
    final subject = widget.assignment.subjectName;

    final res = await FirebaseFirestore.instance.collection('course').get();
    final courses = res.docs.map((e) => Course.fromJson(e.data())).toList();

    for (final course in courses) {
      if (course.subjects.contains(subject)) {
        semester = course.name;
        break;
      }
    }

    final students = await FirebaseFirestore.instance.collection('students').where('semester', isEqualTo: semester).get();
    _students = students.docs.map((e) => Student.fromFirestore(e)).toList();

    widget.assignment.submissions?.removeWhere((element) => !_students.any((student) => student.id == element.studentId));

    setState(() {
      studentLoading = false;
    });
  }

  bool studentLoading = true;

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, size: 24),
            onPressed: () async {
              final delete = await Utils.showDeleteConfirmationDialog(context);
              if (delete == null || !delete) return;

              await FirebaseFirestore.instance.collection('assignments').doc(widget.assignment.id).delete();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignement deleted successfully')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.assignment.topicName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Due: ${widget.assignment.lastSubmissionDate}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.assignment.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (widget.assignment.attachments!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Attachments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.assignment.attachments!.length,
                      itemBuilder: (context, index) {
                        final attachment = widget.assignment.attachments![index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(Icons.attachment),
                            title: Text(attachment.name!),
                            onTap: () async {
                              try {
                                showDialog(
                                  context: context,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                PDFDocument doc = await PDFDocument.fromURL(attachment.url!);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: Text(attachment.name!),
                                      ),
                                      body: PDFViewer(document: doc),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error loading PDF'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Submissions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${studentLoading ? 0 : widget.assignment.submissions?.length}/${_students.length} Submissions',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  studentLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _students.length,
                          itemBuilder: (context, index) {
                            bool isSubmitted = false;
                            Submission? submission;

                            try {
                              submission = widget.assignment.submissions?.firstWhere((element) => element.studentId == _students[index].id);
                              isSubmitted = submission != null;
                            } catch (_) {}

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isSubmitted ? Colors.green.shade100 : Colors.red.shade100,
                                  child: Icon(
                                    isSubmitted ? Icons.check : Icons.close,
                                    color: isSubmitted ? Colors.green : Colors.red,
                                  ),
                                ),
                                title: Text(
                                  _students[index].name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  isSubmitted ? 'Submitted on ${submission?.submittedAt}' : 'Not submitted',
                                  style: TextStyle(
                                    color: isSubmitted ? Colors.green : Colors.red,
                                  ),
                                ),
                                trailing: isSubmitted
                                    ? Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey[400],
                                      )
                                    : null,
                                onTap: isSubmitted
                                    ? () async {
                                        String marks = submission?.marks?.toString() ?? '';
                                        final formkey = GlobalKey<FormState>();

                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            insetPadding: const EdgeInsets.all(12),
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    'Files submitted by ${_students[index].name}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: submission!.files.length,
                                                      itemBuilder: (context, index) {
                                                        final file = submission!.files[index];
                                                        return ListTile(
                                                          leading: Icon(Icons.attachment),
                                                          title: Text(file.name!),
                                                          onTap: () async {
                                                            PDFDocument doc = await PDFDocument.fromURL(file.url!);
                                                            Navigator.pop(context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => Scaffold(
                                                                  appBar: AppBar(
                                                                    title: Text(file.name!),
                                                                  ),
                                                                  body: PDFViewer(document: doc),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }),
                                                  SizedBox(height: 20),
                                                  Form(
                                                    key: formkey,
                                                    child: TextFormField(
                                                      controller: TextEditingController(text: marks),
                                                      decoration: const InputDecoration(
                                                        labelText: 'Marks',
                                                      ),
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                      ],
                                                      onChanged: (value) => marks = value,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Please enter marks';
                                                        }
                                                        final _marks = int.tryParse(value);
                                                        if (_marks == null || _marks < 0 || _marks > 100) {
                                                          return 'Please enter valid marks';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      if (!formkey.currentState!.validate()) return;

                                                      if (submission == null) return;

                                                      final updatedSubmission = submission.giveMarks(marks);
                                                      final updatedSubmissions = widget.assignment.submissions?.map((e) {
                                                        if (e.studentId == submission!.studentId) {
                                                          return updatedSubmission;
                                                        }
                                                        return e;
                                                      }).toList();

                                                      await FirebaseFirestore.instance.collection('assignments').doc(widget.assignment.id).update(
                                                        {
                                                          'submissions': updatedSubmissions?.map((e) => e.toMap()).toList(),
                                                        },
                                                      );

                                                      setState(() {
                                                        widget.assignment.submissions = updatedSubmissions;
                                                      });

                                                      ScaffoldMessenger.of(context).clearSnackBars();
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text('Marks updated successfully'),
                                                        backgroundColor: Colors.green,
                                                      ));

                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Save Marks'),
                                                  ),
                                                  SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
