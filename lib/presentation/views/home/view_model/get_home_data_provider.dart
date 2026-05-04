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

final scanQrCodeProvider =
    StateNotifierProvider<ScanQrCodeProvider, AsyncValue<ResponseModel>>(
      (ref) => ScanQrCodeProvider(dioClient: DioClient()),
    );

class ScanQrCodeProvider extends StateNotifier<AsyncValue<ResponseModel>> {
  DioClient dioClient;

  ScanQrCodeProvider({required this.dioClient}) : super(AsyncValue.loading());

  Future<Object> scanQrCode({required String token}) async {
    var body = {'token': token};
    try {
      final res = await dioClient.postHttp(ApiEndpoints.scanQrCode, body);
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return {'success': false, 'error': res['error']};
      }
    } catch (e) {
      logger.e("Scan Qr Code Error : $e");
      return {'success': false, 'error': '$e'};
    }
  }
}
