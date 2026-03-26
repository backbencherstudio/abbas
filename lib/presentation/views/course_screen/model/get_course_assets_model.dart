class GetCourseAssetsModel {
  bool? success;
  Data? data;

  GetCourseAssetsModel({this.success, this.data});

  GetCourseAssetsModel.fromJson(Map<String, dynamic> json) {
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
  List<Videos>? videos;
  List<Pdfs>? pdfs;

  Data({this.videos, this.pdfs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    if (json['pdfs'] != null) {
      pdfs = <Pdfs>[];
      json['pdfs'].forEach((v) {
        pdfs!.add(Pdfs.formJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    if (pdfs != null) {
      data['pdfs'] = pdfs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  String? moduleId;
  String? moduleTitle;
  String? moduleName;
  List<Assets>? assets;

  Videos({this.moduleId, this.moduleTitle, this.moduleName, this.assets});

  Videos.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
    if (json['assets'] != null) {
      assets = <Assets>[];
      json['assets'].forEach((v) {
        assets!.add(Assets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['module_id'] = moduleId;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
    if (assets != null) {
      data['assets'] = assets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pdfs {
  String? moduleId;
  String? moduleTitle;
  String? moduleName;
  List<Assets>? assets;

  Pdfs({this.moduleId, this.moduleTitle, this.moduleName, this.assets});

  Pdfs.formJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleTitle = json['module_title'];
    moduleName = json['module_name'];
    if (json['assets'] != null) {
      assets = <Assets>[];
      json['assets'].forEach((v) {
        assets!.add(Assets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['module_id'] = moduleId;
    data['module_title'] = moduleTitle;
    data['module_name'] = moduleName;
    if (assets != null) {
      data['assets'] = assets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assets {
  String? id;
  String? classId;
  String? classTitle;
  String? className;
  String? assetUrl;
  String? fileName;

  Assets({
    this.id,
    this.classId,
    this.classTitle,
    this.className,
    this.assetUrl,
    this.fileName,
  });

  Assets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    classTitle = json['class_title'];
    className = json['class_name'];
    assetUrl = json['asset_url'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['class_id'] = classId;
    data['class_title'] = classTitle;
    data['class_name'] = className;
    data['asset_url'] = assetUrl;
    data['file_name'] = fileName;
    return data;
  }
}
