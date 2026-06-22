class GetAssignmentDetailsModel {
  bool? success;
  String? message;
  AssignmentDetailsData? data;

  GetAssignmentDetailsModel({this.success, this.message, this.data});

  GetAssignmentDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null
        ? AssignmentDetailsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
}

class AssignmentDetailsData {
  String? id;
  String? title;
  String? description;
  String? submissionDate;
  int? totalMarks;
  List<AssignmentAttachment>? attachments;
  AssignmentClassInfo? classInfo;
  AssignmentModuleInfo? module;
  String? status;
  int? dueDays;
  String? submittedAt;
  AssignmentSubmission? submission;

  AssignmentDetailsData({
    this.id,
    this.title,
    this.description,
    this.submissionDate,
    this.totalMarks,
    this.attachments,
    this.classInfo,
    this.module,
    this.status,
    this.dueDays,
    this.submittedAt,
    this.submission,
  });

  AssignmentDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    submissionDate = json['submission_date']?.toString();
    totalMarks = json['total_marks'] is int
        ? json['total_marks'] as int
        : int.tryParse(json['total_marks']?.toString() ?? '');
    if (json['attachments'] != null) {
      attachments = (json['attachments'] as List)
          .map((v) => AssignmentAttachment.fromJson(v as Map<String, dynamic>))
          .toList();
    }
    classInfo = json['class'] != null
        ? AssignmentClassInfo.fromJson(json['class'] as Map<String, dynamic>)
        : null;
    module = json['module'] != null
        ? AssignmentModuleInfo.fromJson(json['module'] as Map<String, dynamic>)
        : null;
    status = json['status']?.toString();
    dueDays = json['due_days'] is int
        ? json['due_days'] as int
        : int.tryParse(json['due_days']?.toString() ?? '');
    submittedAt = json['submitted_at']?.toString();
    submission = json['submission'] != null
        ? AssignmentSubmission.fromJson(
            json['submission'] as Map<String, dynamic>,
          )
        : null;
  }

  bool get isPending => status?.toUpperCase() == 'PENDING';
  bool get isSubmitted => status?.toUpperCase() == 'SUBMITTED';
  bool get isGraded => status?.toUpperCase() == 'GRADED';
  bool get hasSubmission => submission != null;
}

class AssignmentAttachment {
  String? fileName;
  String? filePath;
  String? mimeType;

  AssignmentAttachment({this.fileName, this.filePath, this.mimeType});

  AssignmentAttachment.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name']?.toString();
    filePath = json['file_path']?.toString();
    mimeType = json['mime_type']?.toString();
  }

  bool get isPdf =>
      mimeType?.contains('pdf') == true ||
      fileName?.toLowerCase().endsWith('.pdf') == true;

  bool get isImage =>
      mimeType?.startsWith('image/') == true ||
      fileName?.toLowerCase().endsWith('.jpg') == true ||
      fileName?.toLowerCase().endsWith('.jpeg') == true ||
      fileName?.toLowerCase().endsWith('.png') == true;
}

class AssignmentClassInfo {
  String? classTitle;
  String? className;

  AssignmentClassInfo({this.classTitle, this.className});

  AssignmentClassInfo.fromJson(Map<String, dynamic> json) {
    classTitle = json['class_title']?.toString();
    className = json['class_name']?.toString();
  }
}

class AssignmentModuleInfo {
  String? moduleTitle;
  String? moduleName;

  AssignmentModuleInfo({this.moduleTitle, this.moduleName});

  AssignmentModuleInfo.fromJson(Map<String, dynamic> json) {
    moduleTitle = json['module_title']?.toString();
    moduleName = json['module_name']?.toString();
  }
}

class AssignmentSubmission {
  String? description;
  String? submittedAt;
  String? status;
  List<AssignmentAttachment>? attachments;
  List<dynamic>? grades;
  dynamic grade;

  AssignmentSubmission({
    this.description,
    this.submittedAt,
    this.status,
    this.attachments,
    this.grades,
    this.grade,
  });

  AssignmentSubmission.fromJson(Map<String, dynamic> json) {
    description = json['description']?.toString();
    submittedAt = json['submitted_at']?.toString();
    status = json['status']?.toString();
    if (json['attachments'] != null) {
      attachments = (json['attachments'] as List)
          .map((v) => AssignmentAttachment.fromJson(v as Map<String, dynamic>))
          .toList();
    }
    grades = json['grades'] as List<dynamic>?;
    grade = json['grade'];
  }
}
