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
      log('Fetching community feeds from: ${ApiEndpoints.getFeed}');

      final ApiResponseModel response = await apiClient.get(
        ApiEndpoints.getFeed,
        headers: {"Content-Type": "application/json"},
      );

      log('API Response success: ${response.success}');
      log('API Response message: ${response.message}');

      if (response.success) {
        final data = response.data;

        // ডাটা প্রিন্ট করুন ডিবাগ করার জন্য
        log('API Response data type: ${data.runtimeType}');

        if (data is List) {
          log('Data is List with length: ${data.length}');

          // প্রথম আইটেম প্রিন্ট করুন
          if (data.isNotEmpty) {
            log('First item keys: ${(data[0] as Map<String, dynamic>).keys}');
          }

          return data
              .map((e) {
                try {
                  final model = GetFeedModel.fromJson(
                    e as Map<String, dynamic>,
                  );
                  print(
                    'Parsed model postType: ${model.postType}, pollOptions: ${model.pollOptions?.map((p) => p.title).toList()}',
                  );
                  return model;
                } catch (e) {
                  log('Error parsing item: $e');
                  log('Problematic item: $e');
                  return null;
                }
              })
              .whereType<GetFeedModel>() // null গুলো বাদ দিন
              .toList();
        } else if (data is Map<String, dynamic>) {
          log('Data is Map, checking for data field');

          // যদি API data ফিল্ডের মধ্যে List পাঠায়
          if (data.containsKey('data') && data['data'] is List) {
            log(
              'Found data field with list length: ${(data['data'] as List).length}',
            );

            return (data['data'] as List)
                .map((e) => GetFeedModel.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            log("Community API Error: Data is not in expected format");
            throw Exception("Invalid data format: Expected List but got Map");
          }
        } else {
          log("Community API Error: Data is not a List or Map");
          throw Exception("Invalid data format: ${data.runtimeType}");
        }
      } else {
        log("Community API Error: ${response.message}");
        throw Exception(response.message ?? "Unknown error occurred");
      }
    } catch (e) {
      log("CommunityRemoteDataSource Error: $e");
      log("Stack trace: ${StackTrace.current}");
      throw Exception("Failed to load community feeds: ${e.toString()}");
    }
  }
}
