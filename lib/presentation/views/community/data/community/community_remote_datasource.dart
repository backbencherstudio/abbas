import 'dart:developer';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';

import 'community_model.dart';


class CommunityRemoteDataSource {
  final ApiClient apiClient;

  CommunityRemoteDataSource(this.apiClient);

  Future<List<GetFeedModel>> getCommunityFeeds() async {
    final response = await apiClient.get(
      ApiEndpoints.getFeed,
      headers: {"Content-Type": "application/json"},
    );

    if (response['success'] == true) {
      final List data = response['data'] as List<dynamic>;
      return data.map((e) => GetFeedModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      final message = response['message'] ?? "Failed to fetch community feeds";
      log("Community API Error: $message");
      throw Exception(message);
    }
  }
}