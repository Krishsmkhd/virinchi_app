import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/assignment.dart';
import 'package:school_management_app/screens/multi_file_upload.dart';
import 'package:school_management_app/utils/utils.dart';

import '../../models/student.dart';

class SubmitAssignment extends StatefulWidget {
  final Student student;
  final Assignment assignment;
  const SubmitAssignment({super.key, required this.assignment, required this.student});

  @override
  State<SubmitAssignment> createState() => _SubmitAssignmentState();
}

class _SubmitAssignmentState extends State<SubmitAssignment> {
  final List<PlatformFile> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
        elevation: 0,
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
                  const SizedBox(height: 18),
                  Text(
                    'Subject: ${widget.assignment.subjectName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
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
                    Text('Submit your assignment below', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    MultipleFileUpload(
                      onFilesPicked: (pickedFiles) {
                        setState(() {
                          selectedFiles.addAll(pickedFiles);
                        });
                      },
                      selectedFiles: selectedFiles,
                      onFileRemoved: (index) {
                        setState(() {
                          selectedFiles.removeAt(index);
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedFiles.isEmpty) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one file to submit'),
                              ),
                            );
                            return;
                          }
                          EasyLoading.show(status: 'Submitting assignment...');
                          final filePaths = selectedFiles.map((file) => Attachment(name: file.name, url: file.path)).toList();

                          final res = await Utils.uploadFiles(filePaths);

                          await FirebaseFirestore.instance.collection("assignments").doc(widget.assignment.id).update({
                            'submissions': FieldValue.arrayUnion([
                              {
                                'studentId': widget.student.id,
                                'files': res.map((e) => e.toMap()).toList(),
                                'submittedAt': DateTime.now(),
                              }
                            ]),
                          });

                          EasyLoading.dismiss();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Assignment submitted successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Submit Assignment'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
