import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_response_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/presentation/views/home/model/get_home_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final getHomeDataProvider =
    StateNotifierProvider<GetHomeDataProvider, AsyncValue<GetHomeDataModel?>>(
      (ref) => GetHomeDataProvider(dioClient: DioClient()),
    );

class GetHomeDataProvider extends StateNotifier<AsyncValue<GetHomeDataModel?>> {
  DioClient dioClient;

  GetHomeDataProvider({required this.dioClient}) : super(AsyncValue.loading());

  Future<void> getHomeData() async {
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getHomeData);
      final model = GetHomeDataModel.fromJson(res);
      state = AsyncValue.data(model);
    } catch (e, stackTrace) {
      logger.e("Error Fetching Home Data: $e");
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}
