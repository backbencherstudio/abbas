class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.7.12:4000';
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String refreshToken = '$baseUrl/api/auth/refresh-token';
  static const String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static const String resendVerification =
      '$baseUrl/api/auth/resend-verification-email';
  static const String verifyEmail = '$baseUrl/api/auth/verify-email';
  static const String changePassword = '$baseUrl/api/auth/change-password';
  static const String resetPassword = '$baseUrl/api/auth/reset-password';
  static const String changeEmail = '$baseUrl/api/auth/change-email';
  static const String requestChangeEmail =
      '$baseUrl/api/auth/request-email-change';
  static const String updateProfile = '$baseUrl/api/auth/update';
  static const String getProfile = '$baseUrl/api/auth/me';

  static String getOtherProfile(String userId) =>
      '$baseUrl/api/community/profile/$userId';
  static const String editProfile = '$baseUrl/api/auth/update';

  //profile
  static const String profileInfo = '/api/auth/me';

  /// -------------------- Home ------------------------------------------------
  static const String getHomeData = '$baseUrl/api/home';

  /// ------------------- Courses ----------------------------------------------
  static String submitAssignment(String assignmentId) =>
      '$baseUrl/course/assignment/$assignmentId/submit';
  static const String getAllCourses = '$baseUrl/api/course/all';
  static const String getMyCourses = '$baseUrl/api/course/my-courses';

  static String getMyAssignments(String courseId) =>
      '$baseUrl/api/course/assignments/$courseId';

  static String getAssignmentDetails(String assignmentId) =>
      '$baseUrl/api/course/assignments/details/$assignmentId';

  static String getCourseAssets(String courseId) =>
      '$baseUrl/api/course/assets/$courseId';

  static String myCourseDetails(String courseId) =>
      '$baseUrl/api/course/my-course-details/$courseId';

  static String getModuleDetails(String moduleId) =>
      '$baseUrl/api/course/module/$moduleId';

  static String getClassDetails(String classId) =>
      '$baseUrl/api/course/class/$classId';

  static String getCourseDetails(String courseId) =>
      '$baseUrl/api/course/details/$courseId';

  /// ---------------------- Enrollment ----------------------------------------

  static String currentStep(String courseId) =>
      '$baseUrl/api/enrollment/current-step/$courseId';

  static String enrollPersonalInfo(String enrollmentId) =>
      '$baseUrl/api/enrollment/pinfo/$enrollmentId';

  static String acceptRulesRegulations(String enrollmentId) =>
      '$baseUrl/api/enrollment/accept-rules/$enrollmentId';

  static String acceptContractTerms(String enrollmentId) =>
      '$baseUrl/api/enrollment/accept-contract/$enrollmentId';
  static const String createPaymentIntent =
      '$baseUrl/api/payment/stripe/create-intent';

  /// -------------------- Events ----------------------------------------------
  static const String getAllEvents = '$baseUrl/api/events';

  // community

  static String getEventById(String eventId) => '$baseUrl/api/events/$eventId';

  static const String getFeed = '$baseUrl/api/community/feed';
  static const String createPost = '$baseUrl/api/community/post';

  // chat

  static const String createConversation = '$baseUrl/api/conversations/dm';
  static const String allConversationList = '$baseUrl/api/conversations';
  static String dmAllMessage(String conversationId, int cursor, int limit) =>
      '$baseUrl/api/conversations/$conversationId/messages?cursor=&limit=$limit';

  static String dmSendMessage(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/messages';

  //call
  static String startCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/start';

  static String joinCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/join';

  static String endCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/join';
  static const String rtcHealth =
      '$baseUrl/api/rtc/health';

}
