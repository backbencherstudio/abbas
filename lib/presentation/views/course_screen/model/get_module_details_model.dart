class GetModuleDetailsModel {
  bool? success;
  Data? data;

  GetModuleDetailsModel({this.success, this.data});

  GetModuleDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  String? courseId;
  String? createdAt;
  String? updatedAt;
  String? moduleName;
  String? moduleOverview;
  String? moduleTitle;
  List<Classes>? classes;

  Data({
    this.id,
    this.courseId,
    this.createdAt,
    this.updatedAt,
    this.moduleName,
    this.moduleOverview,
    this.moduleTitle,
    this.classes,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['courseId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    moduleName = json['module_name'];
    moduleOverview = json['module_overview'];
    moduleTitle = json['module_title'];
    if (json['classes'] != null) {
      classes = <Classes>[];
      json['classes'].forEach((v) {
        classes!.add(Classes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['courseId'] = courseId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['module_name'] = moduleName;
    data['module_overview'] = moduleOverview;
    data['module_title'] = moduleTitle;
    if (classes != null) {
      data['classes'] = classes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Classes {
  String? id;
  String? classTitle;
  String? className;

  Classes({this.id, this.classTitle, this.className});

  Classes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classTitle = json['class_title'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['class_title'] = classTitle;
    data['class_name'] = className;
    return data;
  }
}
