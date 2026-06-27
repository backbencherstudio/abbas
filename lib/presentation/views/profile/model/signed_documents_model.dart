class SignedDocumentsResponse {
  final bool success;
  final String message;
  final List<SignedCourseDocuments> data;

  SignedDocumentsResponse({
    required this.success,
    this.message = '',
    this.data = const [],
  });

  factory SignedDocumentsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    return SignedDocumentsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawList is List
          ? rawList
                .map(
                  (e) => SignedCourseDocuments.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class SignedCourseDocuments {
  final String? courseId;
  final String? courseName;
  final String? enrolledDate;
  final List<SignedDocument> documents;

  SignedCourseDocuments({
    this.courseId,
    this.courseName,
    this.enrolledDate,
    this.documents = const [],
  });

  factory SignedCourseDocuments.fromJson(Map<String, dynamic> json) {
    final rawDocuments = json['documents'];
    return SignedCourseDocuments(
      courseId: json['course_id']?.toString(),
      courseName: json['course_name']?.toString(),
      enrolledDate: json['enrolled_date']?.toString(),
      documents: rawDocuments is List
          ? rawDocuments
                .map(
                  (e) => SignedDocument.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class SignedDocument {
  final String? type;
  final String? documentName;
  final String? status;
  final String? documentUrl;
  final String? signedDate;

  SignedDocument({
    this.type,
    this.documentName,
    this.status,
    this.documentUrl,
    this.signedDate,
  });

  bool get isReady =>
      status?.toUpperCase() == 'READY' &&
      documentUrl != null &&
      documentUrl!.isNotEmpty;

  factory SignedDocument.fromJson(Map<String, dynamic> json) {
    return SignedDocument(
      type: json['type']?.toString(),
      documentName: json['document_name']?.toString(),
      status: json['status']?.toString(),
      documentUrl: json['document_url']?.toString(),
      signedDate: json['signed_date']?.toString(),
    );
  }
}
