import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/payment_checkout_model.dart';
import 'package:abbas/presentation/views/home/model/get_all_events_model.dart';
import 'package:abbas/presentation/views/home/model/get_event_by_id_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// ------------------------- Get All Events -----------------------------------
final getAllEventsProvider =
    StateNotifierProvider<
      GetAllEventsProvider,
      AsyncValue<List<GetAllEventsModel>>
    >((ref) => GetAllEventsProvider(dioClient: DioClient()));

class GetAllEventsProvider
    extends StateNotifier<AsyncValue<List<GetAllEventsModel>>> {
  DioClient dioClient;

  GetAllEventsProvider({required this.dioClient})
    : super(const AsyncValue.data([]));

  Future<void> getAllEvents() async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getAllEvents);

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res is Map && res['success'] == true) {
        final rawList = res['data'];
        final events = rawList is List
            ? rawList
                  .map(
                    (e) => GetAllEventsModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList()
            : <GetAllEventsModel>[];
        state = AsyncValue.data(events);
        return;
      }

      final message = res is Map
          ? (res['message']?.toString() ?? 'Failed to load events')
          : 'Failed to load events';
      state = AsyncValue.error(message, StackTrace.current);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// -------------------------- Get Event By Id ---------------------------------

final getEventByIdProvider =
    StateNotifierProvider<
      GetEventByIdProvider,
      AsyncValue<GetEventsByIdModel?>
    >((ref) => GetEventByIdProvider(dioClient: DioClient()));

class GetEventByIdProvider
    extends StateNotifier<AsyncValue<GetEventsByIdModel?>> {
  DioClient dioClient;

  GetEventByIdProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getEventById(String eventId) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getEventById(eventId));

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = GetEventsByIdModel.fromJson(
          Map<String, dynamic>.from(res),
        );
        logger.d("Event Details By Id Data $model");
        state = AsyncValue.data(model);
        return;
      }

      final message = res is Map
          ? (res['message']?.toString() ?? 'Failed to load event')
          : 'Failed to load event';
      state = AsyncValue.error(message, StackTrace.current);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// ------------------------ Event Stripe Checkout -----------------------------

final eventStripeCheckoutProvider =
    StateNotifierProvider<EventStripeCheckoutProvider, AsyncValue<bool>>(
      (ref) => EventStripeCheckoutProvider(dioClient: DioClient()),
    );

class EventStripeCheckoutProvider extends StateNotifier<AsyncValue<bool>> {
  DioClient dioClient;

  EventStripeCheckoutProvider({required this.dioClient})
    : super(const AsyncValue.data(false));

  Future<PaymentCheckoutModel> createEventCheckoutSession({
    required String eventId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.stripeCheckout,
        {'event_id': eventId},
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return PaymentCheckoutModel(success: false, message: res.message);
      }

      final model = PaymentCheckoutModel.fromJson(
        Map<String, dynamic>.from(res as Map),
      );

      if (model.success && model.sessionUrl != null) {
        state = const AsyncValue.data(true);
      } else {
        state = AsyncValue.error(
          model.message.isNotEmpty ? model.message : 'Failed to start payment',
          StackTrace.current,
        );
      }

      return model;
    } catch (e, stackTrace) {
      state = AsyncValue.error('$e', stackTrace);
      return PaymentCheckoutModel(success: false, message: '$e');
    }
  }
}
