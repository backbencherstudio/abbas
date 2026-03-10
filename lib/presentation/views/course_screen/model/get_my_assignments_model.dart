class GetMyAssignmentsModel {
  bool? success;
  List<Data>? data;

  GetMyAssignmentsModel({this.success, this.data});

  GetMyAssignmentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? moduleId;
  String? moduleTitle;
  String? moduleName;
  List<Assignments>? assignments;

  Data({this.moduleId, this.moduleTitle, this.moduleName, this.assignments});

  Data.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
    if (json['assignments'] != null) {
      assignments = <Assignments>[];
      json['assignments'].forEach((v) {
        assignments!.add(Assignments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['module_id'] = moduleId;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
    if (assignments != null) {
      data['assignments'] = assignments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assignments {
  String? id;
  String? title;
  String? classId;
  String? classTitle;
  String? className;
  String? moduleId;
  String? moduleTitle;
  String? moduleName;
  String? dueDate;
  int? dueInDays;
  String? dueLabel;
  bool? isOverdue;
  bool? submitted;
  dynamic submittedAt;
  dynamic grade;
  dynamic gradeNumber;
  String? status;

  Assignments({
    this.id,
    this.title,
    this.classId,
    this.classTitle,
    this.className,
    this.moduleId,
    this.moduleTitle,
    this.moduleName,
    this.dueDate,
    this.dueInDays,
    this.dueLabel,
    this.isOverdue,
    this.submitted,
    this.submittedAt,
    this.grade,
    this.gradeNumber,
    this.status,
  });

  Assignments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    classId = json['class_id'];
    classTitle = json['class_title'];
    className = json['class_name'];
    moduleId = json['module_id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
    dueDate = json['due_date'];
    dueInDays = json['due_in_days'];
    dueLabel = json['due_label'];
    isOverdue = json['is_overdue'];
    submitted = json['submitted'];
    submittedAt = json['submittedAt'];
    grade = json['grade'];
    gradeNumber = json['grade_number'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['class_id'] = classId;
    data['class_title'] = classTitle;
    data['class_name'] = className;
    data['module_id'] = moduleId;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
    data['due_date'] = dueDate;
    data['due_in_days'] = dueInDays;
    data['due_label'] = dueLabel;
    data['is_overdue'] = isOverdue;
    data['submitted'] = submitted;
    data['submittedAt'] = submittedAt;
    data['grade'] = grade;
    data['grade_number'] = gradeNumber;
    data['status'] = status;
    return data;
  }
}
