class GetClassDetailsModel {
  bool? success;
  Data? data;

  GetClassDetailsModel({this.success, this.data});

  GetClassDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? moduleId;
  String? classTitle;
  String? className;
  String? classOverview;
  String? duration;
  String? startDate;
  String? classTime;
  String? createdAt;
  String? updatedAt;
  List<Assignments>? assignments;
  ClassAssets? classAssets;

  Data({
    this.id,
    this.moduleId,
    this.classTitle,
    this.className,
    this.classOverview,
    this.duration,
    this.startDate,
    this.classTime,
    this.createdAt,
    this.updatedAt,
    this.assignments,
    this.classAssets,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['moduleId'];
    classTitle = json['class_title'];
    className = json['class_name'];
    classOverview = json['class_overview'];
    duration = json['duration'];
    startDate = json['start_date'];
    classTime = json['class_time'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['assignments'] != null) {
      assignments = <Assignments>[];
      json['assignments'].forEach((v) {
        assignments!.add(Assignments.fromJson(v));
      });
    }
    if (json['classAssets'] != null) {
      classAssets = json['classAssets'] != null
          ? ClassAssets.fromJson(json['classAssets'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['moduleId'] = moduleId;
    data['class_title'] = classTitle;
    data['class_name'] = className;
    data['class_overview'] = classOverview;
    data['duration'] = duration;
    data['start_date'] = startDate;
    data['class_time'] = classTime;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (assignments != null) {
      data['assignments'] = assignments!.map((v) => v.toJson()).toList();
    }
    if (classAssets != null) {
      data['classAssets'] = classAssets!.toJson();
    }
    return data;
  }
}

class Assignments {
  String? id;
  String? title;
  String? dueDate;
  String? status;
  int? dueInDays;
  String? dueLabel;
  bool? isOverdue;

  Assignments({this.id, this.title});

  Assignments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dueDate = json['due_date'];
    status = json['status'];
    dueInDays = json['due_in_days'];
    dueLabel = json['due_label'];
    isOverdue = json['is_overdue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['due_date'] = dueDate;
    data['status'] = status;
    data['due_in_days'] = dueInDays;
    data['due_label'] = dueLabel;
    data['is_overdue'] = isOverdue;
    return data;
  }
}

class ClassAssets {
  List<Videos>? videos;
  List<Pdfs>? pdfs;

  ClassAssets({this.videos, this.pdfs});

  ClassAssets.fromJson(Map<String, dynamic> json) {
    videos = json['videos'] != null
        ? (json['videos'] as List).map((v) => Videos.fromJson(v)).toList()
        : null;
    pdfs = json['pdfs'] != null
        ? (json['pdfs'] as List).map((v) => Pdfs.fromJson(v)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    if (pdfs != null) {
      data['pdfs'] = pdfs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  String? id;
  String? assetUrl;
  String? fileName;

  Videos({this.id, this.assetUrl, this.fileName});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetUrl = json['asset_url'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['asset_url'] = assetUrl;
    data['file_name'] = fileName;
    return data;
  }
}

class Pdfs {
  String? id;
  String? assetUrl;
  String? fileName;

  Pdfs({this.id, this.assetUrl, this.fileName});

  Pdfs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetUrl = json['asset_url'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['asset_url'] = assetUrl;
    data['file_name'] = fileName;
    return data;
  }
}
