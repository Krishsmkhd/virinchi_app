class FeedbackModel {
  final String enquiry;
  final String suggestion;
  final String studentName;
  const FeedbackModel({
    required this.enquiry,
    required this.suggestion,
    required this.studentName,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      enquiry: map['enquiry'],
      suggestion: map['suggestion'],
      studentName: map['studentName'],
    );
  }
}
