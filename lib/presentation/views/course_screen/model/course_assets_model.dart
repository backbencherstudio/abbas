class CourseAssetsModel {
  bool? success;
  String? message;
  List<CourseAssetsModule>? data;

  CourseAssetsModel({this.success, this.message, this.data});

  CourseAssetsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((v) => CourseAssetsModule.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class CourseAssetsModule {
  String? id;
  String? moduleTitle;
  String? moduleName;
  List<CourseAssetsClass>? classes;

  CourseAssetsModule({this.id, this.moduleTitle, this.moduleName, this.classes});

  CourseAssetsModule.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    moduleTitle = json['module_title']?.toString();
    moduleName = json['module_name']?.toString();
    if (json['classes'] != null) {
      classes = (json['classes'] as List)
          .map((v) => CourseAssetsClass.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }

  String get displayTitle {
    final title = moduleTitle ?? '';
    final name = moduleName ?? '';
    if (title.isNotEmpty && name.isNotEmpty) return '$title: $name';
    return title.isNotEmpty ? title : (name.isNotEmpty ? name : 'N/A');
  }

  List<CourseAssetItem> assetsByType(String type) {
    final items = <CourseAssetItem>[];
    final normalizedType = type.toUpperCase();

    for (final cls in classes ?? []) {
      for (final asset in cls.classAssets ?? []) {
        if (asset.type?.toUpperCase() == normalizedType) {
          items.add(asset);
        }
      }
    }

    return items;
  }
}

class CourseAssetsClass {
  String? id;
  String? classTitle;
  String? className;
  List<CourseAssetItem>? classAssets;

  CourseAssetsClass({
    this.id,
    this.classTitle,
    this.className,
    this.classAssets,
  });

  CourseAssetsClass.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    classTitle = json['class_title']?.toString();
    className = json['class_name']?.toString();
    if (json['class_assets'] != null) {
      classAssets = (json['class_assets'] as List)
          .map((v) => CourseAssetItem.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class CourseAssetItem {
  String? id;
  String? type;
  String? fileName;
  String? filePath;
  String? mimeType;

  CourseAssetItem({
    this.id,
    this.type,
    this.fileName,
    this.filePath,
    this.mimeType,
  });

  CourseAssetItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    type = json['type']?.toString();
    fileName = json['file_name']?.toString();
    filePath = json['file_path']?.toString();
    mimeType = json['mime_type']?.toString();
  }

  bool get isVideo => type?.toUpperCase() == 'VIDEO';
  bool get isFile => type?.toUpperCase() == 'FILE';
}
