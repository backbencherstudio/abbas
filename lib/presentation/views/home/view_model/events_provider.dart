import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/presentation/views/home/model/get_all_events_model.dart';
import 'package:abbas/presentation/views/home/model/get_event_by_id_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// ------------------------- Get All Events -----------------------------------
final getAllEventsProvider =
    StateNotifierProvider<GetAllEventsProvider, AsyncValue<GetAllEventsModel?>>(
      (ref) => GetAllEventsProvider(dioClient: DioClient()),
    );

class GetAllEventsProvider
    extends StateNotifier<AsyncValue<GetAllEventsModel?>> {
  DioClient dioClient;

  GetAllEventsProvider({required this.dioClient})
    : super(AsyncValue.data(null));

  Future<void> getAllEvents() async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getAllEvents);
      final model = GetAllEventsModel.fromJson(res);
      state = AsyncValue.data(model);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// -------------------------- Get Event By Id ---------------------------------

class GetEventByIdProvider
    extends StateNotifier<AsyncValue<GetEventsByIdModel?>> {
  DioClient dioClient;

  GetEventByIdProvider({required this.dioClient})
    : super(AsyncValue.data(null));

  Future<void> getEventById(String eventId) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getEventById(eventId));
      final model = GetEventsByIdModel.fromJson(res);
      state = AsyncValue.data(model);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
