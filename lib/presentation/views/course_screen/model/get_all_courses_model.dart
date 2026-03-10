class GetAllCoursesModel {
  bool? success;
  List<Data>? data;

  GetAllCoursesModel({this.success, this.data});

  GetAllCoursesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
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
  String? id;
  String? title;
  String? courseOverview;

  Data({this.id, this.title, this.courseOverview});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    courseOverview = json['course_overview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['course_overview'] = courseOverview;
    return data;
  }
}