class GetModuleDetailsModel {
  bool? success;
  String? message;
  Data? data;

  GetModuleDetailsModel({this.success, this.message, this.data});

  GetModuleDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null
        ? Data.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
}

class Data {
  String? id;
  String? courseId;
  String? moduleName;
  String? moduleOverview;
  String? moduleTitle;
  List<Classes>? classes;

  Data({
    this.id,
    this.courseId,
    this.moduleName,
    this.moduleOverview,
    this.moduleTitle,
    this.classes,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    courseId = json['course_id']?.toString();
    moduleName = json['module_name']?.toString();
    moduleOverview = json['module_overview']?.toString();
    moduleTitle = json['module_title']?.toString();
    if (json['classes'] != null) {
      classes = <Classes>[];
      for (final item in json['classes'] as List) {
        classes!.add(Classes.fromJson(item as Map<String, dynamic>));
      }
    }
  }
}

class Classes {
  String? id;
  String? classTitle;
  String? className;
  String? classAt;
  String? startAt;
  String? endAt;
  int? duration;
  String? status;

  Classes({
    this.id,
    this.classTitle,
    this.className,
    this.classAt,
    this.startAt,
    this.endAt,
    this.duration,
    this.status,
  });

  Classes.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    classTitle = json['class_title']?.toString();
    className = json['class_name']?.toString();
    classAt = json['class_at']?.toString();
    startAt = json['start_at']?.toString();
    endAt = json['end_at']?.toString();
    duration = json['duration'] is int
        ? json['duration'] as int
        : int.tryParse(json['duration']?.toString() ?? '');
    status = json['status']?.toString();
  }

  bool get isNext => status?.toUpperCase() == 'NEXT';

  String get displayTitle {
    final title = classTitle ?? '';
    final name = className ?? '';
    if (title.isNotEmpty && name.isNotEmpty) return '$title: $name';
    return title.isNotEmpty ? title : (name.isNotEmpty ? name : 'N/A');
  }
}
