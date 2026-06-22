class GetClassDetailsModel {
  bool? success;
  String? message;
  Data? data;

  GetClassDetailsModel({this.success, this.message, this.data});

  GetClassDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null
        ? Data.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
}

class Data {
  String? id;
  String? moduleId;
  String? classTitle;
  String? className;
  String? classOverview;
  int? duration;
  String? classAt;
  String? startAt;
  String? endAt;
  List<Assignments>? assignments;
  ClassAssets? classAssets;

  Data({
    this.id,
    this.moduleId,
    this.classTitle,
    this.className,
    this.classOverview,
    this.duration,
    this.classAt,
    this.startAt,
    this.endAt,
    this.assignments,
    this.classAssets,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    moduleId = json['module_id']?.toString();
    classTitle = json['class_title']?.toString();
    className = json['class_name']?.toString();
    classOverview = json['class_overview']?.toString();
    duration = json['duration'] is int
        ? json['duration'] as int
        : int.tryParse(json['duration']?.toString() ?? '');
    classAt = json['class_at']?.toString();
    startAt = json['start_at']?.toString();
    endAt = json['end_at']?.toString();
    if (json['assignments'] != null) {
      assignments = <Assignments>[];
      for (final item in json['assignments'] as List) {
        assignments!.add(Assignments.fromJson(item as Map<String, dynamic>));
      }
    }
    if (json['class_assets'] != null) {
      classAssets = ClassAssets.fromJson(
        json['class_assets'] as Map<String, dynamic>,
      );
    } else if (json['classAssets'] != null) {
      classAssets = ClassAssets.fromJson(
        json['classAssets'] as Map<String, dynamic>,
      );
    }
  }

  String get displayTitle {
    final title = classTitle ?? '';
    final name = className ?? '';
    if (title.isNotEmpty && name.isNotEmpty) return '$title: $name';
    return title.isNotEmpty ? title : (name.isNotEmpty ? name : 'N/A');
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

  Assignments({
    this.id,
    this.title,
    this.dueDate,
    this.status,
    this.dueInDays,
    this.dueLabel,
    this.isOverdue,
  });

  Assignments.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    dueDate = json['due_date']?.toString();
    status = json['status']?.toString();
    dueInDays = json['due_in_days'] is int
        ? json['due_in_days'] as int
        : int.tryParse(json['due_in_days']?.toString() ?? '');
    dueLabel = json['due_label']?.toString();
    isOverdue = json['is_overdue'] == true;
  }
}

class ClassAssets {
  List<Videos>? videos;
  List<Pdfs>? pdfs;

  ClassAssets({this.videos, this.pdfs});

  ClassAssets.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = (json['videos'] as List)
          .map((v) => Videos.fromJson(v as Map<String, dynamic>))
          .toList();
    }
    if (json['pdfs'] != null) {
      pdfs = (json['pdfs'] as List)
          .map((v) => Pdfs.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class Videos {
  String? id;
  String? assetUrl;
  String? fileName;

  Videos({this.id, this.assetUrl, this.fileName});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    assetUrl = json['asset_url']?.toString();
    fileName = json['file_name']?.toString();
  }
}

class Pdfs {
  String? id;
  String? assetUrl;
  String? fileName;

  Pdfs({this.id, this.assetUrl, this.fileName});

  Pdfs.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    assetUrl = json['asset_url']?.toString();
    fileName = json['file_name']?.toString();
  }
}
