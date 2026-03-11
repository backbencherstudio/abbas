class MyCourseDetailsModel {
  bool? success;
  Data? data;

  MyCourseDetailsModel({this.success, this.data});

  MyCourseDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
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
  dynamic nextClass;
  bool? isEnrolled;

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
        this.nextClass,
        this.isEnrolled});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startDate = json['start_date'];
    title = json['title'];
    createdBy = json['createdBy'];
    instructorId = json['instructorId'];
    fee = json['fee'];
    courseOverview = json['course_overview'];
    courseModuleDetails = json['course_module_details'];
    installmentProcess = json['installment_process'];
    seatCapacity = json['seat_capacity'];
    classTime = json['class_time'];
    duration = json['duration'];
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
    nextClass = json['nextClass'];
    isEnrolled = json['isEnrolled'];
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
    data['nextClass'] = nextClass;
    data['isEnrolled'] = isEnrolled;
    return data;
  }
}

class Modules {
  String? id;
  String? moduleTitle;
  String? moduleName;

  Modules({this.id, this.moduleTitle, this.moduleName});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
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
