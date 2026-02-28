class AppUtils {

  static String extractErrorMessage(dynamic responseData) {
    if (responseData is Map) {
      if (responseData.containsKey('message')) {
        if (responseData['message'] is Map) {
          return responseData['message']['message'] ?? 'Unauthorized access';
        } else if (responseData['message'] is String) {
          return responseData['message'];
        }
      }
      return responseData.toString();
    }
    return 'Unknown error occurred';
  }

}
