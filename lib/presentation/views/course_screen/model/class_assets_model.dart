class ClassAssetsModel {
  bool? success;
  String? message;
  ClassAssetsData? data;

  ClassAssetsModel({this.success, this.message, this.data});

  ClassAssetsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null
        ? ClassAssetsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
}

class ClassAssetsData {
  List<ClassAssetItem>? videos;
  List<ClassAssetItem>? files;

  ClassAssetsData({this.videos, this.files});

  ClassAssetsData.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = (json['videos'] as List)
          .map((v) => ClassAssetItem.fromJson(v as Map<String, dynamic>))
          .toList();
    }
    if (json['files'] != null) {
      files = (json['files'] as List)
          .map((v) => ClassAssetItem.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }
}

class ClassAssetItem {
  String? id;
  String? type;
  String? fileName;
  String? filePath;
  String? mimeType;

  ClassAssetItem({
    this.id,
    this.type,
    this.fileName,
    this.filePath,
    this.mimeType,
  });

  ClassAssetItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    type = json['type']?.toString();
    fileName = json['file_name']?.toString();
    filePath = json['file_path']?.toString();
    mimeType = json['mime_type']?.toString();
  }

  bool get isVideo => type?.toUpperCase() == 'VIDEO';
  bool get isPdf =>
      mimeType?.contains('pdf') == true ||
      fileName?.toLowerCase().endsWith('.pdf') == true;
}
