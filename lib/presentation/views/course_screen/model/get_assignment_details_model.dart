class GetAssignmentDetailsModel {
  bool? success;
  Data? data;

  GetAssignmentDetailsModel({this.success, this.data});

  GetAssignmentDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? description;
  String? submissionDate;
  String? dueDate;
  int? totalMarks;
  List<String>? attachmentUrl;
  int? averageScore;
  String? createdAt;
  String? teacherId;
  String? moduleClassId;
  ModuleClass? moduleClass;

  Data(
      {this.id,
        this.title,
        this.description,
        this.submissionDate,
        this.dueDate,
        this.totalMarks,
        this.attachmentUrl,
        this.averageScore,
        this.createdAt,
        this.teacherId,
        this.moduleClassId,
        this.moduleClass});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    submissionDate = json['submission_Date'];
    dueDate = json['due_date'];
    totalMarks = json['total_marks'];
    attachmentUrl = json['attachment_url'].cast<String>();
    averageScore = json['average_score'];
    createdAt = json['createdAt'];
    teacherId = json['teacherId'];
    moduleClassId = json['moduleClassId'];
    moduleClass = json['moduleClass'] != null
        ? ModuleClass.fromJson(json['moduleClass'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['submission_Date'] = submissionDate;
    data['due_date'] = dueDate;
    data['total_marks'] = totalMarks;
    data['attachment_url'] = attachmentUrl;
    data['average_score'] = averageScore;
    data['createdAt'] = createdAt;
    data['teacherId'] = teacherId;
    data['moduleClassId'] = moduleClassId;
    if (moduleClass != null) {
      data['moduleClass'] = moduleClass!.toJson();
    }
    return data;
  }
}

class ModuleClass {
  String? id;
  String? classTitle;
  String? className;
  Module? module;

  ModuleClass({this.id, this.classTitle, this.className, this.module});

  ModuleClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classTitle = json['class_title'];
    className = json['class_name'];
    module =
    json['module'] != null ?  Module.fromJson(json['module']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['class_title'] = classTitle;
    data['class_name'] = className;
    if (module != null) {
      data['module'] = module!.toJson();
    }
    return data;
  }
}

class Module {
  String? id;
  String? moduleTitle;
  String? moduleName;
  String? createdAt;

  Module({this.id, this.moduleTitle, this.moduleName, this.createdAt});

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
    data['createdAt'] = createdAt;
    return data;
  }
}
