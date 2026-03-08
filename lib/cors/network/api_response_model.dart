class ApiResponseModel {
  final bool success;
  final dynamic data;
  final String message;

  ApiResponseModel({required this.success, this.data, required this.message});
}