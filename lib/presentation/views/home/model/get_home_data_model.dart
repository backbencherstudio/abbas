class GetHomeDataModel {
  UpcomingClasses? upcomingClasses;
  UpcomingAssignments? upcomingAssignments;
  UpcomingEvents? upcomingEvents;

  GetHomeDataModel({
    this.upcomingClasses,
    this.upcomingAssignments,
    this.upcomingEvents,
  });

  GetHomeDataModel.fromJson(Map<String, dynamic> json) {
    upcomingClasses = json['upcoming_classes'] != null
        ? UpcomingClasses.fromJson(
            json['upcoming_classes'] as Map<String, dynamic>,
          )
        : null;
    upcomingAssignments = json['upcoming_assignments'] != null
        ? UpcomingAssignments.fromJson(
            json['upcoming_assignments'] as Map<String, dynamic>,
          )
        : null;
    upcomingEvents = json['upcoming_events'] != null
        ? UpcomingEvents.fromJson(
            json['upcoming_events'] as Map<String, dynamic>,
          )
        : null;
  }
}

class UpcomingClasses {
  String? id;
  String? classTitle;
  String? className;
  String? duration;
  String? startDate;
  String? classTime;
  String? classAt;
  String? moduleName;
  String? moduleTitle;
  String? courseTitle;
  String? instructorName;

  UpcomingClasses({
    this.id,
    this.classTitle,
    this.className,
    this.duration,
    this.startDate,
    this.classTime,
    this.classAt,
    this.moduleName,
    this.moduleTitle,
    this.courseTitle,
    this.instructorName,
  });

  UpcomingClasses.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    classTitle = json['class_title']?.toString();
    className = json['class_name']?.toString();
    duration = json['duration']?.toString();
    startDate = json['start_date']?.toString() ?? json['class_at']?.toString();
    classTime = json['class_time']?.toString();
    classAt = json['class_at']?.toString();
    moduleName = json['module_name']?.toString();
    moduleTitle = json['module_title']?.toString();
    courseTitle = json['course_title']?.toString();
    instructorName = json['instructor_name']?.toString();
  }

  String get displayTitle {
    final module = moduleTitle ?? '';
    final classLabel = classTitle ?? className ?? '';
    if (module.isNotEmpty && classLabel.isNotEmpty) {
      return '$module ($classLabel)';
    }
    return module.isNotEmpty ? module : (classLabel.isNotEmpty ? classLabel : 'N/A');
  }
}

class UpcomingAssignments {
  String? id;
  String? title;
  String? dueDate;
  int? totalMarks;
  String? teacherName;
  String? courseTitle;
  int? dueDays;

  UpcomingAssignments({
    this.id,
    this.title,
    this.dueDate,
    this.totalMarks,
    this.teacherName,
    this.courseTitle,
    this.dueDays,
  });

  UpcomingAssignments.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    dueDate = json['due_date']?.toString();
    totalMarks = json['total_marks'] is int
        ? json['total_marks'] as int
        : int.tryParse(json['total_marks']?.toString() ?? '');
    teacherName = json['teacher_name']?.toString();
    courseTitle = json['course_title']?.toString();
    dueDays = json['due_days'] is int
        ? json['due_days'] as int
        : int.tryParse(json['due_days']?.toString() ?? '');
  }

  String get dueLabel {
    if (dueDays != null) {
      if (dueDays == 0) return 'Due today';
      if (dueDays == 1) return 'Due in 1 day';
      return 'Due in $dueDays days';
    }
    return 'Due date unavailable';
  }
}

class UpcomingEvents {
  String? id;
  String? name;
  String? description;
  String? date;
  String? time;
  String? location;
  bool? isMember;

  UpcomingEvents({
    this.id,
    this.name,
    this.description,
    this.date,
    this.time,
    this.location,
    this.isMember,
  });

  UpcomingEvents.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    date = json['date']?.toString();
    time = json['time']?.toString();
    location = json['location']?.toString();
    isMember = json['is_member'] == true;
  }
}
