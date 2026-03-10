class MyCoursesModel {
  bool? success;
  Data? data;

  MyCoursesModel({this.success, this.data});

  MyCoursesModel.fromJson(Map<String, dynamic> json) {
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
  List<MyCourses>? myCourses;
  List<Null>? otherCourses;

  Data({this.myCourses, this.otherCourses});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['myCourses'] != null) {
      myCourses = <MyCourses>[];
      json['myCourses'].forEach((v) {
        myCourses!.add(MyCourses.fromJson(v));
      });
    }
    if (json['otherCourses'] != null) {
      otherCourses = <Null>[];
      // json['otherCourses'].forEach((v) {
      //   otherCourses!.add(Null.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (myCourses != null) {
      data['myCourses'] = myCourses!.map((v) => v.toJson()).toList();
    }
    // if (otherCourses != null) {
    //   data['otherCourses'] = otherCourses!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class MyCourses {
  String? id;
  String? title;
  String? courseOverview;
  int? modulesCount;
  int? totalClasses;
  int? attendedClasses;
  int? progressPercent;
  String? progressLabel;
  String? infoLine;

  MyCourses({
    this.id,
    this.title,
    this.courseOverview,
    this.modulesCount,
    this.totalClasses,
    this.attendedClasses,
    this.progressPercent,
    this.progressLabel,
    this.infoLine,
  });

  MyCourses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    courseOverview = json['course_overview'];
    modulesCount = json['modulesCount'];
    totalClasses = json['totalClasses'];
    attendedClasses = json['attendedClasses'];
    progressPercent = json['progressPercent'];
    progressLabel = json['progressLabel'];
    infoLine = json['infoLine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['course_overview'] = courseOverview;
    data['modulesCount'] = modulesCount;
    data['totalClasses'] = totalClasses;
    data['attendedClasses'] = attendedClasses;
    data['progressPercent'] = progressPercent;
    data['progressLabel'] = progressLabel;
    data['infoLine'] = infoLine;
    return data;
  }
}
