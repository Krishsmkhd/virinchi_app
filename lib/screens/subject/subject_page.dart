// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/student.dart';

class SubjectPage extends StatefulWidget {
  final Student student;
  const SubjectPage({
    super.key,
    required this.student,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  bool _loading = true;
  List subjects = [];
  late List<ExpansionTileController> controllers;

  void getSubject() async {
    final db = FirebaseFirestore.instance;
    final data = await db.collection('course').get();
    subjects = data.docs.map((e) => e.data()).toList();
    subjects.sort((a, b) => (a['index'] as int) - (b['index'] as int));
    setState(() {});
    _loading = false;
  }

  @override
  void initState() {
    super.initState();
    getSubject();
    controllers = List.generate(8, (index) => ExpansionTileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: subjects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final isCurrent = widget.student.semester == subjects[index]['name'];
                return ExpansionTile(
                  key: Key(index.toString()),
                  controller: controllers[index],
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      for (var i = 0; i < controllers.length; i++) {
                        if (i != index) {
                          controllers[i].collapse();
                        }
                      }
                    }
                  },
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  ),
                  backgroundColor: isCurrent ? AppColor.primary : Colors.white,
                  collapsedBackgroundColor: isCurrent ? AppColor.primary : Colors.white,
                  textColor: isCurrent ? Colors.white : Colors.black,
                  collapsedTextColor: isCurrent ? Colors.white : Colors.black,
                  iconColor: isCurrent ? Colors.white : Colors.black,
                  collapsedIconColor: isCurrent ? Colors.white : Colors.black,
                  title: Text(
                    subjects[index]['name'] as String,
                  ),
                  children: (subjects[index]['sub'] as List<dynamic>).map((sub) {
                    return ListTile(
                        title: Text(
                          sub,
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.black,
                          ),
                        ),
                        onTap: () async {
                          final res = await FirebaseFirestore.instance.collection('subject_details').doc(sub).get();
                          final url = res.data()?['pdfUrl']?['url'];
                          if (url == null) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No PDF found for this subject'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          } else {
                            EasyLoading.showInfo('Loading PDF...');
                            final pdf = await PDFDocument.fromURL(url);
                            EasyLoading.dismiss();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(sub),
                                  ),
                                  body: PDFViewer(document: pdf),
                                ),
                              ),
                            );
                          }
                        });
                  }).toList(),
                );
              },
            ),
    );
  }
}
