
import '../../../cors/constants/api_endpoints.dart';
import '../../../cors/services/api_services.dart';
import '../../../domain/entities/community/feed.dart';
import '../../models/community/feed_response.dart';


abstract class FeedRemoteDataSource {
  Future<List<Feed>> getFeeds();
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiService apiService;

  FeedRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Feed>> getFeeds() async {
    try {
      final response = await apiService.get(ApiEndpoints.getFeed);
      final list = response.data as List;
      return list
          .map((e) => FeedResponse.fromJson(e))
          .map((feedResponse) => feedResponse.toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
