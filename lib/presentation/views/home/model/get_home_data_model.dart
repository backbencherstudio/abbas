class GetHomeDataModel {
  UserProfile? userProfile;
  UpcomingClasses? upcomingClasses;
  UpcomingAssignments? upcomingAssignments;
  UpcomingEvents? upcomingEvents;

  GetHomeDataModel({
    this.userProfile,
    this.upcomingClasses,
    this.upcomingAssignments,
    this.upcomingEvents,
  });

  GetHomeDataModel.fromJson(Map<String, dynamic> json) {
    userProfile = json['userProfile'] != null
        ? UserProfile.fromJson(json['userProfile'])
        : null;
    upcomingClasses = json['upcomingClasses'] != null
        ? UpcomingClasses.fromJson(json['upcomingClasses'])
        : null;
    upcomingAssignments = json['upcomingAssignments'] != null
        ? UpcomingAssignments.fromJson(json['upcomingAssignments'])
        : null;
    upcomingEvents = json['upcomingEvents'] != null
        ? UpcomingEvents.fromJson(json['upcomingEvents'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userProfile != null) {
      data['userProfile'] = userProfile!.toJson();
    }
    if (upcomingClasses != null) {
      data['upcomingClasses'] = upcomingClasses!.toJson();
    }
    if (upcomingAssignments != null) {
      data['upcomingAssignments'] = upcomingAssignments!.toJson();
    }
    if (upcomingEvents != null) {
      data['upcomingEvents'] = upcomingEvents!.toJson();
    }
    return data;
  }
}

class UserProfile {
  String? name;

  UserProfile({this.name});

  UserProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    return data;
  }
}

class UpcomingClasses {
  String? id;
  String? classTitle;
  String? className;
  String? duration;
  String? startDate;
  String? classTime;
  String? moduleName;
  String? moduleTitle;
  String? courseTitle;
  String? instructorName;
  List<dynamic>? materials;

  UpcomingClasses({
    this.id,
    this.classTitle,
    this.className,
    this.duration,
    this.startDate,
    this.classTime,
    this.moduleName,
    this.moduleTitle,
    this.courseTitle,
    this.instructorName,
    this.materials,
  });

  UpcomingClasses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classTitle = json['class_title'];
    className = json['class_name'];
    duration = json['duration'];
    startDate = json['start_date'];
    classTime = json['class_time'];
    moduleName = json['module_name'];
    moduleTitle = json['module_title'];
    courseTitle = json['course_title'];
    instructorName = json['instructor_name'];
    if (json['materials'] != null) {
      materials = <dynamic>[];
      json['materials'].forEach((v) {
        // materials!.add( Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['class_title'] = classTitle;
    data['class_name'] = className;
    data['duration'] = duration;
    data['start_date'] = startDate;
    data['class_time'] = classTime;
    data['module_name'] = moduleName;
    data['module_title'] = moduleTitle;
    data['course_title'] = courseTitle;
    data['instructor_name'] = instructorName;
    if (materials != null) {
      data['materials'] = materials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingAssignments {
  String? id;
  String? title;
  String? dueDate;
  String? submissionDate;
  int? totalMarks;
  String? teacherName;
  String? courseTitle;

  UpcomingAssignments({
    this.id,
    this.title,
    this.dueDate,
    this.submissionDate,
    this.totalMarks,
    this.teacherName,
    this.courseTitle,
  });

  UpcomingAssignments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dueDate = json['due_date'];
    submissionDate = json['submission_Date'];
    totalMarks = json['total_marks'];
    teacherName = json['teacher_name'];
    courseTitle = json['course_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['due_date'] = dueDate;
    data['submission_Date'] = submissionDate;
    data['total_marks'] = totalMarks;
    data['teacher_name'] = teacherName;
    data['course_title'] = courseTitle;
    return data;
  }
}

class UpcomingEvents {
  String? id;
  String? name;
  String? description;
  dynamic overview;
  String? date;
  String? time;
  String? location;
  String? amount;
  dynamic creatorName;
  bool? isMember;

  UpcomingEvents({
    this.id,
    this.name,
    this.description,
    this.overview,
    this.date,
    this.time,
    this.location,
    this.amount,
    this.creatorName,
    this.isMember,
  });

  UpcomingEvents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    overview = json['overview'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    amount = json['amount'];
    creatorName = json['creator_name'];
    isMember = json['is_member'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['overview'] = overview;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['amount'] = amount;
    data['creator_name'] = creatorName;
    data['is_member'] = isMember;
    return data;
  }
}
