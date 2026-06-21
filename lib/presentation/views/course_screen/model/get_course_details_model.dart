class GetCourseDetailsModel {
  bool? success;
  Data? data;

  GetCourseDetailsModel({this.success, this.data});

  GetCourseDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? createdAt;
  String? updatedAt;
  String? startDate;
  String? title;
  String? createdBy;
  String? instructorId;
  String? fee;
  String? courseOverview;
  String? courseModuleDetails;
  String? installmentProcess;
  String? seatCapacity;
  String? classTime;
  String? duration;
  String? status;
  List<Modules>? modules;
  Instructor? instructor;
  bool? isEnrolled;
  Schedule? schedule;
  String? scheduleLabel;
  int? modulesCount;
  List<String>? modulesList;
  String? overviewText;
  List<dynamic>? includes;

  Data(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.startDate,
        this.title,
        this.createdBy,
        this.instructorId,
        this.fee,
        this.courseOverview,
        this.courseModuleDetails,
        this.installmentProcess,
        this.seatCapacity,
        this.classTime,
        this.duration,
        this.status,
        this.modules,
        this.instructor,
        this.isEnrolled,
        this.schedule,
        this.scheduleLabel,
        this.modulesCount,
        this.modulesList,
        this.overviewText,
        this.includes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startDate = json['start_date'];
    title = json['title'];
    createdBy = json['createdBy'];
    instructorId = json['instructorId'];
    fee = json['fee']?.toString();
    courseOverview = json['course_overview']?.toString();
    courseModuleDetails = json['course_module_details']?.toString();
    installmentProcess = json['installment_process']?.toString();
    seatCapacity = json['seat_capacity']?.toString();
    classTime = json['class_time']?.toString();
    duration = json['duration']?.toString();
    status = json['status'];
    if (json['modules'] != null) {
      modules = <Modules>[];
      json['modules'].forEach((v) {
        modules!.add( Modules.fromJson(v));
      });
    }
    instructor = json['instructor'] != null
        ?  Instructor.fromJson(json['instructor'])
        : null;
    isEnrolled = json['is_enrolled'] == true || json['isEnrolled'] == true;
    schedule = json['schedule'] != null
        ? Schedule.fromJson(json['schedule'])
        : null;
    scheduleLabel = json['scheduleLabel']?.toString();
    modulesCount = json['modulesCount'] is int
        ? json['modulesCount'] as int
        : int.tryParse(json['modulesCount']?.toString() ?? '');
    if (json['modulesList'] != null) {
      modulesList = List<String>.from(json['modulesList']);
    }
    overviewText = json['overviewText']?.toString();
    if (json['includes'] != null) {
      includes = List<dynamic>.from(json['includes']);
    }
    if (modulesCount == null && modules != null) {
      modulesCount = modules!.length;
    }
  }

  bool get isAlreadyEnrolled => isEnrolled == true;

  String? get formattedStartDate {
    if (startDate == null || startDate!.isEmpty) return null;
    final parsed = DateTime.tryParse(startDate!);
    if (parsed == null) return null;
    return '${parsed.day}/${parsed.month}/${parsed.year}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['start_date'] = startDate;
    data['title'] = title;
    data['createdBy'] = createdBy;
    data['instructorId'] = instructorId;
    data['fee'] = fee;
    data['course_overview'] = courseOverview;
    data['course_module_details'] = courseModuleDetails;
    data['installment_process'] = installmentProcess;
    data['seat_capacity'] = seatCapacity;
    data['class_time'] = classTime;
    data['duration'] = duration;
    data['status'] = status;
    if (modules != null) {
      data['modules'] = modules!.map((v) => v.toJson()).toList();
    }
    if (instructor != null) {
      data['instructor'] = instructor!.toJson();
    }
    data['isEnrolled'] = isEnrolled;
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    data['scheduleLabel'] = scheduleLabel;
    data['modulesCount'] = modulesCount;
    data['modulesList'] = modulesList;
    data['overviewText'] = overviewText;
    if (includes != null) {
      data['includes'] = includes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modules {
  String? id;
  String? moduleTitle;
  String? moduleName;
  int? classesCount;

  Modules({this.id, this.moduleTitle, this.moduleName, this.classesCount});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
    classesCount = json['classesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
    data['classesCount'] = classesCount;
    return data;
  }
}

class Instructor {
  String? id;
  String? name;
  dynamic avatar;
  dynamic about;

  Instructor({this.id, this.name, this.avatar, this.about});

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['about'] = about;
    return data;
  }
}

class Schedule {
  String? day;
  String? time;
  String? label;

  Schedule({this.day, this.time, this.label});

  Schedule.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['day'] = day;
    data['time'] = time;
    data['label'] = label;
    return data;
  }
}
