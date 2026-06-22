class ClassAssignmentsModel {
  bool? success;
  String? message;
  List<ClassAssignmentItem>? data;

  ClassAssignmentsModel({this.success, this.message, this.data});

  ClassAssignmentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((v) => ClassAssignmentItem.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class ClassAssignmentItem {
  String? id;
  String? title;
  String? description;
  String? submissionDate;
  int? totalMarks;
  String? status;
  int? dueDays;

  ClassAssignmentItem({
    this.id,
    this.title,
    this.description,
    this.submissionDate,
    this.totalMarks,
    this.status,
    this.dueDays,
  });

  ClassAssignmentItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    submissionDate = json['submission_date']?.toString();
    totalMarks = json['total_marks'] is int
        ? json['total_marks'] as int
        : int.tryParse(json['total_marks']?.toString() ?? '');
    status = json['status']?.toString();
    dueDays = json['due_days'] is int
        ? json['due_days'] as int
        : int.tryParse(json['due_days']?.toString() ?? '');
  }

  bool get isSubmitted => status?.toUpperCase() == 'SUBMITTED';
  bool get isPending => status?.toUpperCase() == 'PENDING';
  bool get isGraded => status?.toUpperCase() == 'GRADED';
}
