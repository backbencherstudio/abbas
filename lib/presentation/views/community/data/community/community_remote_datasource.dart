import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'community_model.dart';

class CommunityRemoteDataSource {
  final ApiClient apiClient;

  CommunityRemoteDataSource(this.apiClient);

  Future<List<GetFeedModel>> getCommunityFeeds({String? userId}) async {
    try {
      String url = ApiEndpoints.getFeed;
      if (userId != null && userId.isNotEmpty) {
        url = "$url?userId=$userId";
      }

      final response = await apiClient.get(url);

      if (response.data is List) {
        final List<dynamic> dataList = response.data as List;
        return dataList
            .map((json) => GetFeedModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      logger.e('Error fetching feeds: $e');
      throw Exception('Failed to load feeds: $e');
    }
  }
}
