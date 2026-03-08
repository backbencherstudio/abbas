import 'dart:developer';
import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';
import '../../../../../cors/network/api_response_model.dart';
import 'community_model.dart';

class CommunityRemoteDataSource {
  final ApiClient apiClient;

  CommunityRemoteDataSource(this.apiClient);

  Future<List<GetFeedModel>> getCommunityFeeds() async {
    try {
      // call GET via ApiClient
      final ApiResponseModel response = await apiClient.get(
        ApiEndpoints.getFeed,
        headers: {"Content-Type": "application/json"},
      );

      if (response.success) {
        final data = response.data;
        if (data is List) {
          // map each item to GetFeedModel
          return data
              .map((e) => GetFeedModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          log("Community API Error: Data is not a list");
          throw Exception("Invalid data format");
        }
      } else {
        log("Community API Error: ${response.message}");
        throw Exception(response.message);
      }
    } catch (e) {
      log("CommunityRemoteDataSource Error: $e");
      throw Exception(e.toString());
    }
  }
}