class GetAllCoursesModel {
  final String? success;
  final List<Data>? data;

  GetAllCoursesModel({required this.success, required this.data});

  factory GetAllCoursesModel.formJson(Map<String, dynamic> json) {
    List<Data> courseList = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        courseList.add(Data.fromJson(v));
      });
    }
    return GetAllCoursesModel(success: json['success'], data: courseList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['success'] = success;

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    return dataMap;
  }
}

class Data {
  final String? id;
  final String? title;
  final String? courseOverview;

  Data({required this.id, required this.title, required this.courseOverview});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
      courseOverview: json['course_overview'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['title'] = title;
    data['course_overview'] = courseOverview;

    return data;
  }
}
