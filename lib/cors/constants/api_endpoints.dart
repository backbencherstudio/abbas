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

  /// ------------------- Courses ----------------------------------------------
  static String submitAssignment(String assignmentId) =>
      '$baseUrl/course/assignment/$assignmentId/submit';
  static const String getAllCourses = '$baseUrl/api/course/all';
  static const String getMyCourses = '$baseUrl/course/my-courses';

  static String getMyAssignments(String courseId) =>
      '$baseUrl/course/assignments/$courseId';

  static String getAssignmentDetails(String assignmentId) =>
      '$baseUrl/course/assignments/details/$assignmentId';

  static String getCourseAssets(String assetsId) =>
      '$baseUrl/course/assets/$assetsId';

  static String getModuleDetails(String moduleId) =>
      '$baseUrl/course/module/$moduleId';

  static String getClassDetails(String classId) =>
      '$baseUrl/course/class/$classId';

  static String getCourseDetails(String courseId) =>
      '$baseUrl/api/course/details/$courseId';

  /// ---------------------- Enrollment ----------------------------------------

  static String enrollPersonalInfo(String enrollmentId) =>
      '$baseUrl/api/enrollment/pinfo/$enrollmentId';

  static String acceptRulesRegulations(String enrollmentId) =>
      '$baseUrl/api/enrollment/accept-rules/$enrollmentId';

  static String acceptContractTerms(String enrollmentId) =>
      '$baseUrl/api/enrollment/accept-contract/$enrollmentId';
  static const String createPaymentIntent =
      '$baseUrl/payment/stripe/create-intent';

  static const String getFeed = '$baseUrl/api/community/feed';
}
