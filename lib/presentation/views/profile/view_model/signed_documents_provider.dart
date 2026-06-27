import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/profile/model/signed_documents_model.dart';
import 'package:flutter/material.dart';

class SignedDocumentsProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  String? _error;
  List<SignedCourseDocuments> _courses = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<SignedCourseDocuments> get courses => _courses;

  Future<void> fetchSignedDocuments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _dioClient.getHttp(ApiEndpoints.signedDocuments);

      if (res is ResponseModel) {
        _error = res.message;
        _courses = [];
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = SignedDocumentsResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        _courses = model.data;
        return;
      }

      _error = res is Map
          ? (res['message']?.toString() ?? 'Failed to load contract documents')
          : 'Failed to load contract documents';
      _courses = [];
    } catch (e) {
      _error = '$e';
      _courses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
