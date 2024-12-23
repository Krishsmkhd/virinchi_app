import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:school_management_app/models/assignment.dart';
import 'package:school_management_app/models/teacher.dart';
import 'package:school_management_app/screens/multi_file_upload.dart';
import 'package:school_management_app/utils/utils.dart';

import '../../constant/color_const.dart';

class GiveAssignment extends StatefulWidget {
  final Teacher teacher;
  const GiveAssignment({super.key, required this.teacher});

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<GiveAssignment> {
  final _formKey = GlobalKey<FormState>();
  late String _topicName;
  late String _assignmentdetail;
  final DateTime _assignDate = DateTime.now();
  DateTime _lastSubmissionDate = DateTime.now();
  TimeOfDay _lastSubmissionTime = const TimeOfDay(hour: 23, minute: 59);
  final List<PlatformFile> _files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give Assignment'),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Title'),
                const SizedBox(height: 8),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  onChanged: (value) => setState(() => _topicName = value),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter title name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(padding: EdgeInsets.all(10), child: Text('Assignment Detail')),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  onChanged: (value) => setState(() => _assignmentdetail = value),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter assignment detail';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter Assignment detail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 26),
                const Text('Last Submission Date and Time'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _lastSubmissionDate,
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null && picked != _lastSubmissionDate) {
                          setState(() => _lastSubmissionDate = picked);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${_lastSubmissionDate.day}/${_lastSubmissionDate.month}/${_lastSubmissionDate.year}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null && picked != _lastSubmissionTime) {
                          setState(() => _lastSubmissionTime = picked);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            to12hr(_lastSubmissionTime),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const Text('Attachments'),
                const SizedBox(height: 8),
                MultipleFileUpload(
                  selectedFiles: _files,
                  onFilesPicked: (pickedFiles) => setState(
                    () => _files.addAll(pickedFiles),
                  ),
                  onFileRemoved: (index) => setState(
                    () => _files.removeAt(index),
                  ),
                ),
                const SizedBox(height: 26),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: AppColor.primary,
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      FocusScope.of(context).unfocus();
                      EasyLoading.show(status: 'Creating assignment...');
                      final filePaths = _files.map((file) => Attachment(name: file.name, url: file.path)).toList();

                      final res = await Utils.uploadFiles(filePaths);

                      FirebaseFirestore.instance.collection("assignments").add(
                        {
                          'subject': widget.teacher.subject,
                          'topicName': _topicName,
                          'description': _assignmentdetail,
                          'assignedDate': "${_assignDate.day}/${_assignDate.month}/${_assignDate.year} ${to12hrFromDateTime(_assignDate)}",
                          'lastSubmissionDate':
                              "${_lastSubmissionDate.day}/${_lastSubmissionDate.month}/${_lastSubmissionDate.year} ${to12hr(_lastSubmissionTime)}",
                          'attachments': res.map((e) => e.toMap()).toList(),
                        },
                      );

                      EasyLoading.dismiss();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Assignment created successfully'),
                        ),
                      );

                      Navigator.pop(context);
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String to12hrFromDateTime(DateTime dateTime) {
  return DateFormat('h:mm a').format(dateTime);
}

String to12hr(TimeOfDay dateTime) {
  return DateFormat('h:mm a').format(
    DateTime(0, 0, 0, dateTime.hour, dateTime.minute),
  );
}
