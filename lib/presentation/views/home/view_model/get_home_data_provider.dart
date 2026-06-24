import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_response_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/home/model/get_home_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final getHomeDataProvider =
    StateNotifierProvider<GetHomeDataProvider, AsyncValue<GetHomeDataModel?>>(
      (ref) => GetHomeDataProvider(dioClient: DioClient()),
    );

class GetHomeDataProvider extends StateNotifier<AsyncValue<GetHomeDataModel?>> {
  DioClient dioClient;

  GetHomeDataProvider({required this.dioClient}) : super(const AsyncValue.loading());

  Future<void> getHomeData() async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getHomeData);

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success'] == true && res['data'] != null) {
        final model = GetHomeDataModel.fromJson(
          Map<String, dynamic>.from(res['data'] as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Failed to load overview',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      logger.e("Error Fetching Home Data: $e");
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}
