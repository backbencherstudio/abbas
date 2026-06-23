class GetAllCoursesModel {
  bool? success;
  String? message;
  List<CourseListItem>? data;

  GetAllCoursesModel({this.success, this.message, this.data});

  GetAllCoursesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CourseListItem>[];
      for (final item in json['data'] as List) {
        data!.add(CourseListItem.fromJson(item as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
    };
  }
}

class CourseListItem {
  String? id;
  String? title;
  int? duration;
  String? startDate;
  int? moduleCount;
  bool? isEnrolled;
  double? courseProgress;

  CourseListItem({
    this.id,
    this.title,
    this.duration,
    this.startDate,
    this.moduleCount,
    this.isEnrolled,
    this.courseProgress,
  });

  CourseListItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    duration = json['duration'] is int
        ? json['duration'] as int
        : int.tryParse(json['duration']?.toString() ?? '');
    startDate = json['start_date']?.toString();
    moduleCount = json['module_count'] is int
        ? json['module_count'] as int
        : int.tryParse(json['module_count']?.toString() ?? '');
    isEnrolled = json['is_enrolled'] == true;
    courseProgress = json['course_progress'] is num
        ? (json['course_progress'] as num).toDouble()
        : double.tryParse(json['course_progress']?.toString() ?? '');
  }

  double get progressFraction =>
      ((courseProgress ?? 0).clamp(0, 100)) / 100;

  String get progressLabel =>
      '${(courseProgress ?? 0).round()}% Complete';

  String get infoLine {
    final parts = <String>[];
    if (moduleCount != null) {
      parts.add('$moduleCount module${moduleCount == 1 ? '' : 's'}');
    }
    if (duration != null) {
      parts.add('$duration min');
    }
    return parts.join(' · ');
  }

  String get formattedStartDate {
    if (startDate == null || startDate!.isEmpty) return '';
    final parsed = DateTime.tryParse(startDate!);
    if (parsed == null) return '';
    return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
  }

  String get subtitleLine {
    final parts = <String>[];
    if (infoLine.isNotEmpty) parts.add(infoLine);
    if (formattedStartDate.isNotEmpty) parts.add(formattedStartDate);
    return parts.join(' · ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'start_date': startDate,
      'module_count': moduleCount,
      'is_enrolled': isEnrolled,
      'course_progress': courseProgress,
    };
  }
}

/// Kept for backward compatibility with existing imports/usages.
typedef Data = CourseListItem;
