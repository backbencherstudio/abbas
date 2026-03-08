class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.7.12:4000';
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String refreshToken = '$baseUrl/api/auth/refresh-token';
  static const String forgetPasswordEmail =
      '$baseUrl/api/auimportth/resend-verification-email';
  static const String verifyEmail = '$baseUrl/api/auth/verify-email';
  static const String changePassword = '$baseUrl/api/auth/change-password';
  static const String resetPassword = '$baseUrl/api/auth/reset-password';
  static const String updateProfile = '$baseUrl/api/auth/update';
  static const String getProfile = '$baseUrl/api/auth/me';

  //profile
  static const String profileInfo = '/api/auth/me';

  /// ---------------------- Enrollment ----------------------------------------
  static const String getAllCourses = '$baseUrl/api/course/all';

  static const String getFeed = '$baseUrl/api/community/feed';

  static String getCourseDetails(String courseId) =>
      '$baseUrl/api/course/details/$courseId';
}
