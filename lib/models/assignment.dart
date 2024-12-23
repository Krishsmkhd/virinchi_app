import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String id;
  String subjectName;
  String topicName;
  String description;
  String assignedDate;
  String lastSubmissionDate;
  List<Attachment>? attachments;
  List<Submission>? submissions;

  Assignment({
    required this.id,
    required this.subjectName,
    required this.topicName,
    required this.description,
    required this.assignedDate,
    required this.lastSubmissionDate,
    required this.attachments,
    required this.submissions,
  });

  factory Assignment.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Assignment(
      id: doc.id,
      subjectName: data['subject'] ?? '',
      topicName: data['topicName'] ?? '',
      description: data['description'] ?? '',
      assignedDate: data['assignedDate'] ?? '',
      lastSubmissionDate: data['lastSubmissionDate'] ?? '',
      attachments: (data['attachments'] as List?)?.map((e) => Attachment.fromMap(e)).toList(),
      submissions: (data['submissions'] as List?)?.map((e) => Submission.fromMap(e)).toList(),
    );
  }
}

class Attachment {
  final String? name;
  final String? url;

  const Attachment({required this.name, required this.url});

  factory Attachment.fromMap(Map<String, dynamic> data) {
    return Attachment(name: data['name'], url: data['url']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'url': url};
  }
}

class Submission {
  final String studentId;
  final List<Attachment> files;
  final String submittedAt;
  final String? marks;

  const Submission({
    required this.studentId,
    required this.files,
    required this.submittedAt,
    this.marks,
  });

  factory Submission.fromMap(Map<String, dynamic> data) {
    return Submission(
      studentId: data['studentId'],
      files: (data['files'] as List).map((e) => Attachment.fromMap(e)).toList(),
      submittedAt: data['submittedAt'] is Timestamp ? (data['submittedAt'] as Timestamp).toDate().toString() : data['submittedAt'],
      marks: data['marks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'files': files.map((e) => e.toMap()).toList(),
      'submittedAt': submittedAt,
      if (marks != null) 'marks': marks,
    };
  }

  Submission giveMarks(String marks) {
    return Submission(
      studentId: studentId,
      files: files,
      submittedAt: submittedAt,
      marks: marks,
    );
  }
}
