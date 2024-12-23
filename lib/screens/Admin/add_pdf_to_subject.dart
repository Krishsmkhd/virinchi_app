import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/assignment.dart';

import '../../utils/utils.dart';

class AddPdfToSubject extends StatefulWidget {
  const AddPdfToSubject({super.key});

  @override
  State<AddPdfToSubject> createState() => _AddPdfToSubjectState();
}

class _AddPdfToSubjectState extends State<AddPdfToSubject> {
  late Future<List<Subject>> _subjectsFuture;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _fetchSubjectsWithPdfStatus();
  }

  Future<List<Subject>> _fetchSubjectsWithPdfStatus() async {
    List<String> subjects = await Utils.getSubject();

    List<Subject> subjectsWithStatus = await Future.wait(
      subjects.map((subjectName) async {
        final res = await _firestore
            .collection('subject_details')
            .doc(subjectName)
            .get();

        return Subject(
          name: subjectName,
          url: res.exists ? res.data()?['pdfUrl']?['url'] : null,
        );
      }),
    );

    return subjectsWithStatus;
  }

  Future<void> _uploadPdf(String subjectName) async {
    try {
      EasyLoading.show(status: 'Uploading PDF...');

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result == null) {
        EasyLoading.dismiss();
        return;
      }
      List<Attachment> attachments = result.files
          .map((e) => Attachment(name: e.name, url: e.path))
          .toList();
      final res = await Utils.uploadFiles(attachments);

      await _firestore
          .collection('subject_details')
          .doc(subjectName)
          .set({'pdfUrl': res.first.toMap()}, SetOptions(merge: true));

      EasyLoading.dismiss();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _refreshData();
    } catch (e) {
      Navigator.pop(context);
      _showErrorSnackbar('Upload failed: ${e.toString()}');
    }
  }

  Future<void> _deletePdf(String subjectId) async {
    try {
      final doc =
          await _firestore.collection('subject_details').doc(subjectId).get();
      if (doc.exists) {
        await _firestore.collection('subject_details').doc(subjectId).update({
          'pdfUrl': FieldValue.delete(),
        });
        _refreshData();
      }
    } catch (e) {
      _showErrorSnackbar('Deletion failed: ${e.toString()}');
    }
  }

  void _refreshData() {
    setState(() {
      _subjectsFuture = _fetchSubjectsWithPdfStatus();
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Subject PDFs'),
        elevation: 0,
        backgroundColor: AppColor.primary,
      ),
      body: FutureBuilder<List<Subject>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final subjects = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return _buildSubjectCard(subject);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubjectCard(Subject subject) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  subject.url != null
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: subject.url != null ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (subject.url != null)
                  ElevatedButton.icon(
                    icon:
                        const Icon(Icons.delete, size: 18, color: Colors.white),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 40),
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _deletePdf(subject.name),
                  )
                else
                  ElevatedButton.icon(
                    icon:
                        const Icon(Icons.upload, size: 18, color: Colors.white),
                    label: const Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 40),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _uploadPdf(subject.name),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Subject {
  final String name;
  final String? url;

  Subject({
    required this.name,
    this.url,
  });
}
