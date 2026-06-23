class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      // 'http://192.168.7.12:4000';
      'http://10.10.9.51:7777';

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

  ///----------------------- profile -------------------------------------------
  static const String profileInfo = '/api/auth/me';
  static const String accountGetProfile = '$baseUrl/api/profile';
  static const String deleteAccount = '$baseUrl/api/profile/delete-account';

  /// -------------------- Home ------------------------------------------------
  static const String getHomeData = '$baseUrl/api/overview';
  static const String scanQrCode = '$baseUrl/api/attendance/scan-qr';

  /// ------------------- Courses ----------------------------------------------
  static String submitAssignment(String assignmentId) =>
      '$baseUrl/api/courses/modules/classes/assignments/$assignmentId';
  static const String getAllCourses = '$baseUrl/api/courses';
  static const String getEnrolledCourses =
      '$baseUrl/api/courses?my_courses=true';

  static String getMyAssignments(String courseId) =>
      '$baseUrl/api/courses/$courseId/assignments';

  static String getAssignmentDetails(String assignmentId) =>
      '$baseUrl/api/courses/modules/classes/assignments/$assignmentId';

  static String getCourseAssets(String courseId, {String? type}) {
    final base = '$baseUrl/api/courses/$courseId/assets';
    if (type != null && type.isNotEmpty) return '$base?type=$type';
    return base;
  }

  static String myCourseDetails(String courseId) =>
      '$baseUrl/api/courses/$courseId';

  static String getModuleDetails(String moduleId) =>
      '$baseUrl/api/courses/modules/$moduleId';

  static String getClassDetails(String classId) =>
      '$baseUrl/api/courses/modules/classes/$classId';

  static String getClassAssets(String classId) =>
      '$baseUrl/api/courses/modules/classes/$classId/assets';

  static String getClassAssignments(String classId) =>
      '$baseUrl/api/courses/modules/classes/$classId/assignments';

  static String getCourseDetails(String courseId) =>
      '$baseUrl/api/courses/$courseId';

  /// ---------------------- Enrollment ----------------------------------------

  static String enrollmentCurrentStep(String courseId) =>
      '$baseUrl/api/courses/$courseId/enrollment/current_step';

  static String courseEnrollment(String courseId) =>
      '$baseUrl/api/courses/$courseId/enrollment';

  @Deprecated('Use enrollmentCurrentStep')
  static String currentStep(String courseId) => enrollmentCurrentStep(courseId);

  @Deprecated('Use courseEnrollment with step FORM_FILLING')
  static String enrollPersonalInfo(String enrollmentId) =>
      '$baseUrl/api/enrollment/pinfo/$enrollmentId';

  @Deprecated('Use courseEnrollment with step RULES_SIGNING')
  static String acceptRulesRegulations(String enrollmentId) =>
      '$baseUrl/api/enrollment/accept-rules/$enrollmentId';

  @Deprecated('Use courseEnrollment with step CONTRACT_SIGNING')
  static String acceptContractTerms(String enrollmentId) =>
      '$baseUrl/api/enrollment/accept-contract/$enrollmentId';
  static const String stripeCheckout = '$baseUrl/api/payment/stripe/checkout';

  @Deprecated('Use stripeCheckout')
  static const String createPaymentIntent =
      '$baseUrl/api/payment/stripe/create-intent';

  /// -------------------- Events ----------------------------------------------
  static const String getAllEvents = '$baseUrl/api/events';

  static String getEventById(String eventId) => '$baseUrl/api/events/$eventId';

  /// -------------------- Community -------------------------------------------
  static const String getFeed = '$baseUrl/api/community/feed';

  static String communityFeed({
    String? cursor,
    int limit = 10,
    String? userId,
  }) {
    final cursorValue = (cursor != null && cursor.isNotEmpty) ? cursor : '';
    final base =
        '$baseUrl/api/community/feed?cursor=$cursorValue&limit=$limit';
    if (userId != null && userId.isNotEmpty) {
      return '$base&user_id=$userId';
    }
    return base;
  }
  static const String createPost = '$baseUrl/api/community/post';

  static String updatePost(String postId) =>
      '$baseUrl/api/community/post/$postId';
  static const String createPostLike = '$baseUrl/api/community/like';

  static String getPostLike(String postId) =>
      '$baseUrl/api/community/like/$postId';

  static String createComment(String postId) =>
      '$baseUrl/api/community/comment/$postId';

  static String getComment(String postId) =>
      '$baseUrl/api/community/comment/$postId';

  static String replyComment(String postId) =>
      '$baseUrl/api/community/comment/reply/$postId';

  static String deletePost(String postId) =>
      '$baseUrl/api/community/post/$postId';
  static const String createPoll = '$baseUrl/api/community/post';

  static String report(String userId) =>
      '$baseUrl/api/community/report/$userId';
  static const String editMyProfile = '$baseUrl/api/community/edit-profile';
  static const String getMyProfile = '$baseUrl/api/community/my-profile';

  static String voteOnAPoll(String postId, String optionId) =>
      '$baseUrl/api/community/post/$postId/vote/$optionId';

  /// ----- Community: post like / comments (current API) ----------------------
  static String likePost(String postId) =>
      '$baseUrl/api/community/posts/$postId/like';

  static String getPostComments(String postId, {String? cursor, int limit = 10}) {
    final cursorValue = (cursor != null && cursor.isNotEmpty) ? cursor : '';
    return '$baseUrl/api/community/post/$postId/comments?cursor=$cursorValue&limit=$limit';
  }

  static String createPostComment(String postId) =>
      '$baseUrl/api/community/post/$postId/comment';

  static String likeComment(String commentId) =>
      '$baseUrl/api/community/posts/comments/$commentId/like';

  static String deleteComment(String commentId) =>
      '$baseUrl/api/community/posts/comments/$commentId/delete';


  // chat
  static const String createConversation = '$baseUrl/api/conversations/dm';
  static const String allConversationList = '$baseUrl/api/conversations';
  static const String groupConversationList =
      '$baseUrl/api/conversations/group-conversations';
  static const String createGroupChat = '$baseUrl/api/conversations/group';

  static String searchUser(String query) =>
      '$baseUrl/api/users/suggest?q=$query';

  static String getConversationUnread(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/unread';

  static String markConversationRead(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/read';

  static String clearConversation(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/clear';

  static String conversationMembers(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/members';

  static String updateMemberRole(String conversationId, String userId) =>
      '$baseUrl/api/conversations/$conversationId/members/$userId/role';

  static String removeMember(String conversationId, String userId) =>
      '$baseUrl/api/conversations/$conversationId/members/$userId/remove';

  static String dmAllMessage(String conversationId, int take, String? cursor) {
    if (cursor != null && cursor.isNotEmpty) {
      return '$baseUrl/api/conversations/$conversationId/messages?take=$take&cursor=$cursor';
    } else {
      return '$baseUrl/api/conversations/$conversationId/messages?take=$take';
    }
  }

  static String uploadConversationMessage(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/messages/upload';

  static String deleteMessage(String messageId) =>
      '$baseUrl/api/messages/$messageId';

  static String reportMessage(String messageId) =>
      '$baseUrl/api/messages/$messageId/report';

  static String searchMessages({
    required String query,
    String? conversationId,
    int take = 20,
    int skip = 0,
  }) {
    final conversationPart = (conversationId != null && conversationId.isNotEmpty)
        ? '&conversationId=$conversationId'
        : '';
    return '$baseUrl/api/messages/search?q=$query$conversationPart&take=$take&skip=$skip';
  }

  static String conversationMedia(String conversationId, {int take = 20, String? cursor}) {
    final cursorPart = (cursor != null && cursor.isNotEmpty) ? '&cursor=$cursor' : '';
    return '$baseUrl/api/conversations/$conversationId/media?take=$take$cursorPart';
  }

  static String conversationFiles(String conversationId, {int take = 20, String? cursor}) {
    final cursorPart = (cursor != null && cursor.isNotEmpty) ? '&cursor=$cursor' : '';
    return '$baseUrl/api/conversations/$conversationId/files?take=$take$cursorPart';
  }

  static String blockUser(String userId) =>
      '$baseUrl/api/users/$userId/block';

  static String unblockUser(String userId) =>
      '$baseUrl/api/users/$userId/unblock';

  static const String socketNamespace = '$baseUrl/ws';

// call
  static String startCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/start';

  static String joinCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/join';

  static String endCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/end';

  static String leaveCall(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/leave';

  static String getToken(String conversationId) =>
      '$baseUrl/api/rtc/conversations/$conversationId/token';

  static const String rtcHealth = '$baseUrl/api/rtc/health';


  static String dmSendMessage(String conversationId) =>
      '$baseUrl/api/conversations/$conversationId/messages';

}
