class MyCourseDetailsModel {
  bool? success;
  String? message;
  Data? data;

  MyCourseDetailsModel({this.success, this.message, this.data});

  MyCourseDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? id;
  String? title;
  String? courseOverview;
  String? startDate;
  int? fee;
  int? feePence;
  bool? isEnrolled;
  List<Modules>? modules;
  Instructor? instructor;
  NextClass? nextClass;

  Data({
    this.id,
    this.title,
    this.courseOverview,
    this.startDate,
    this.fee,
    this.feePence,
    this.isEnrolled,
    this.modules,
    this.instructor,
    this.nextClass,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    courseOverview = json['course_overview']?.toString();
    startDate = json['start_date']?.toString();
    fee = json['fee'] is int
        ? json['fee'] as int
        : int.tryParse(json['fee']?.toString() ?? '');
    feePence = json['fee_pence'] is int
        ? json['fee_pence'] as int
        : int.tryParse(json['fee_pence']?.toString() ?? '');
    isEnrolled = json['is_enrolled'] == true;
    if (json['modules'] != null) {
      modules = <Modules>[];
      for (final item in json['modules'] as List) {
        modules!.add(Modules.fromJson(item as Map<String, dynamic>));
      }
    }
    instructor = json['instructor'] != null
        ? Instructor.fromJson(json['instructor'] as Map<String, dynamic>)
        : null;
    nextClass = json['next_class'] != null
        ? NextClass.fromJson(json['next_class'] as Map<String, dynamic>)
        : null;
  }
}

class Modules {
  String? id;
  String? moduleTitle;
  String? moduleName;

  Modules({this.id, this.moduleTitle, this.moduleName});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    moduleTitle = json['module_title']?.toString();
    moduleName = json['module_name']?.toString();
  }
}

class Instructor {
  String? id;
  String? name;
  dynamic avatar;
  dynamic about;

  Instructor({this.id, this.name, this.avatar, this.about});

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    avatar = json['avatar'];
    about = json['about'];
  }
}

class NextClass {
  String? id;
  String? className;
  String? classTitle;
  String? classAt;
  int? duration;
  String? startAt;
  NextClassModule? module;

  NextClass({
    this.id,
    this.className,
    this.classTitle,
    this.classAt,
    this.duration,
    this.startAt,
    this.module,
  });

  NextClass.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    className = json['class_name']?.toString();
    classTitle = json['class_title']?.toString();
    classAt = json['class_at']?.toString();
    duration = json['duration'] is int
        ? json['duration'] as int
        : int.tryParse(json['duration']?.toString() ?? '');
    startAt = json['start_at']?.toString();
    module = json['module'] != null
        ? NextClassModule.fromJson(json['module'] as Map<String, dynamic>)
        : null;
  }

  String get displayTitle {
    final title = classTitle ?? '';
    final name = className ?? '';
    if (title.isNotEmpty && name.isNotEmpty) return '$title: $name';
    return title.isNotEmpty ? title : (name.isNotEmpty ? name : 'N/A');
  }
}

class NextClassModule {
  String? moduleTitle;
  String? moduleName;

  NextClassModule({this.moduleTitle, this.moduleName});

  NextClassModule.fromJson(Map<String, dynamic> json) {
    moduleTitle = json['module_title']?.toString();
    moduleName = json['module_name']?.toString();
  }
}
