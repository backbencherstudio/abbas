import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/current_step_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/payment_checkout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// ---------------------- Current Step ----------------------------------------

final currentStepProvider =
    StateNotifierProvider<CurrentStepProvider, AsyncValue<CurrentStepModel?>>(
      (ref) => CurrentStepProvider(dioClient: DioClient()),
    );

class CurrentStepProvider extends StateNotifier<AsyncValue<CurrentStepModel?>> {
  DioClient dioClient;

  CurrentStepProvider({required this.dioClient}) : super(AsyncValue.data(null));

  Future<void> currentStep({required String courseId}) async {
    state = AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.enrollmentCurrentStep(courseId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success'] == true) {
        state = AsyncValue.data(CurrentStepModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        ));
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Error loading enrollment step',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('$e', stackTrace);
    }
  }
}

/// ------------------------ Step 1 - Form Filling -----------------------------

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

final enrollPersonalInfoProvider =
    StateNotifierProvider<EnrollPersonalInfoProvider, ResponseModel>(
      (ref) => EnrollPersonalInfoProvider(dioClient: DioClient()),
    );

class EnrollPersonalInfoProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  EnrollPersonalInfoProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  Future<ResponseModel> submitFormFilling({
    required String courseId,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String dateOfBirth,
    required String experience,
    required String actingGoals,
  }) async {
    final body = {
      'step': 'FORM_FILLING',
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth,
      'experience': experience,
      'acting_goals': actingGoals,
    };

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.courseEnrollment(courseId),
        body,
      );

      if (res is ResponseModel) return res;

      if (res['success'] == true) {
        return ResponseModel(
          success: true,
          message: res['message']?.toString() ?? 'Submitted successfully',
        );
      }

      return ResponseModel(
        success: false,
        message: res['message']?.toString() ?? 'Failed to submit form',
      );
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }
}

/// ------------------------ Step 2 - Rules Signing --------------------------

final acknowledgeProvider = StateProvider<bool>((ref) => false);

final acceptRulesRegulationsProvider =
    StateNotifierProvider<
      AcceptRulesRegulationsProvider,
      AsyncValue<ResponseModel>
    >((ref) => AcceptRulesRegulationsProvider(dioClient: DioClient()));

class AcceptRulesRegulationsProvider
    extends StateNotifier<AsyncValue<ResponseModel>> {
  DioClient dioClient;

  AcceptRulesRegulationsProvider({required this.dioClient})
    : super(AsyncValue.data(ResponseModel(success: false, message: '')));

  Future<ResponseModel> acceptRulesRegulations({
    required String courseId,
    required bool rulesAccepted,
    required String signatureFullName,
    required String signature,
    required String signatureDate,
  }) async {
    final body = {
      'step': 'RULES_SIGNING',
      'rules_accepted': rulesAccepted,
      'signature_full_name': signatureFullName,
      'signature': signature,
      'signature_date': signatureDate,
    };

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.courseEnrollment(courseId),
        body,
      );

      if (res is ResponseModel) return res;

      if (res['success'] == true) {
        return ResponseModel(
          success: true,
          message: res['message']?.toString() ?? 'Submitted successfully',
        );
      }

      return ResponseModel(
        success: false,
        message: res['message']?.toString() ?? 'Failed to submit rules',
      );
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }
}

/// -------------------------- Step 3 - Contract Signing ---------------------

final acceptContractTermsProvider =
    StateNotifierProvider<AcceptContractTermsProvider, ResponseModel>(
      (ref) => AcceptContractTermsProvider(dioClient: DioClient()),
    );

class AcceptContractTermsProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  AcceptContractTermsProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  Future<ResponseModel> acceptContractTerms({
    required String courseId,
    required bool termsAccepted,
    required String signatureFullName,
    required String signature,
    required String signatureDate,
  }) async {
    final body = {
      'step': 'CONTRACT_SIGNING',
      'terms_accepted': termsAccepted,
      'signature_full_name': signatureFullName,
      'signature': signature,
      'signature_date': signatureDate,
    };

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.courseEnrollment(courseId),
        body,
      );

      if (res is ResponseModel) return res;

      if (res['success'] == true) {
        return ResponseModel(
          success: true,
          message: res['message']?.toString() ?? 'Submitted successfully',
        );
      }

      return ResponseModel(
        success: false,
        message: res['message']?.toString() ?? 'Failed to submit contract',
      );
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }
}

/// ------------------------ Stripe Checkout -----------------------------------

final stripeCheckoutProvider =
    StateNotifierProvider<StripeCheckoutProvider, AsyncValue<bool>>(
      (ref) => StripeCheckoutProvider(dioClient: DioClient()),
    );

class StripeCheckoutProvider extends StateNotifier<AsyncValue<bool>> {
  DioClient dioClient;

  StripeCheckoutProvider({required this.dioClient})
    : super(const AsyncValue.data(false));

  Future<PaymentCheckoutModel> createCheckoutSession({
    required String enrollmentId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.stripeCheckout,
        {'enrollment_id': enrollmentId},
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
