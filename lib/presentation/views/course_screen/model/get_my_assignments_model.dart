class GetMyAssignmentsModel {
  bool? success;
  String? message;
  List<CourseAssignmentModule>? data;

  GetMyAssignmentsModel({this.success, this.message, this.data});

  GetMyAssignmentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((v) => CourseAssignmentModule.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class CourseAssignmentModule {
  String? moduleTitle;
  String? moduleName;
  List<CourseAssignmentClass>? classes;

  CourseAssignmentModule({this.moduleTitle, this.moduleName, this.classes});

  CourseAssignmentModule.fromJson(Map<String, dynamic> json) {
    moduleTitle = json['module_title']?.toString();
    moduleName = json['module_name']?.toString();
    if (json['classes'] != null) {
      classes = (json['classes'] as List)
          .map((v) => CourseAssignmentClass.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }

  List<CourseAssignmentItem> get allAssignments {
    final items = <CourseAssignmentItem>[];
    for (final cls in classes ?? []) {
      items.addAll(cls.assignments ?? []);
    }
    return items;
  }

  String get displayTitle {
    final title = moduleTitle ?? '';
    final name = moduleName ?? '';
    if (title.isNotEmpty && name.isNotEmpty) return '$title: $name';
    return title.isNotEmpty ? title : (name.isNotEmpty ? name : 'N/A');
  }
}

class CourseAssignmentClass {
  String? classTitle;
  String? className;
  List<CourseAssignmentItem>? assignments;

  CourseAssignmentClass({this.classTitle, this.className, this.assignments});

  CourseAssignmentClass.fromJson(Map<String, dynamic> json) {
    classTitle = json['class_title']?.toString();
    className = json['class_name']?.toString();
    if (json['assignments'] != null) {
      assignments = (json['assignments'] as List)
          .map((v) => CourseAssignmentItem.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class CourseAssignmentItem {
  String? id;
  String? title;
  String? description;
  String? submissionDate;
  int? totalMarks;
  String? status;
  int? dueDays;
  String? grade;

  CourseAssignmentItem({
    this.id,
    this.title,
    this.description,
    this.submissionDate,
    this.totalMarks,
    this.status,
    this.dueDays,
    this.grade,
  });

  CourseAssignmentItem.fromJson(Map<String, dynamic> json) {
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
    grade = json['grade']?.toString();
  }

  bool get isPending => status?.toUpperCase() == 'PENDING';
  bool get isSubmitted => status?.toUpperCase() == 'SUBMITTED';
  bool get isGraded => status?.toUpperCase() == 'GRADED';

  String get dueLabel {
    if (dueDays == null) return 'Due';
    if (dueDays == 1) return 'Due 1 day';
    return 'Due $dueDays days';
  }
}
