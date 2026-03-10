class GetClassDetailsModel {
  bool? success;
  Data? data;

  GetClassDetailsModel({this.success, this.data});

  GetClassDetailsModel.fromJson(Map<String, dynamic> json) {
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
  List<Null>? classAssets;

  Data(
      {this.id,
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
        this.classAssets});

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
        assignments!.add( Assignments.fromJson(v));
      });
    }
    if (json['classAssets'] != null) {
      classAssets = <Null>[];
      // json['classAssets'].forEach((v) {
      //   classAssets!.add(new Null.fromJson(v));
      // });
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
    // if (classAssets != null) {
    //   data['classAssets'] = classAssets!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Assignments {
  String? id;
  String? title;

  Assignments({this.id, this.title});

  Assignments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
