import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/enroll_personal_info_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/get_all_courses_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/get_course_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// ------------------ Get All Courses Provider --------------------------------
final getAllCoursesProvider =
    StateNotifierProvider<
      GetAllCoursesProvider,
      AsyncValue<GetAllCoursesModel?>
    >((ref) => GetAllCoursesProvider(dioClient: DioClient()));

class GetAllCoursesProvider
    extends StateNotifier<AsyncValue<GetAllCoursesModel?>> {
  DioClient dioClient;

  GetAllCoursesProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getAllCourses() async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getAllCourses);
      if (res['success']) {
        logger.d("${res['success']}");
        final model = GetAllCoursesModel.fromJson(res);
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error('Failed to load course ', StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error : $e");
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// ------------------------- Get Course Details -------------------------------

final getCourseDetailsProvider =
    StateNotifierProvider<
      GetCourseDetailsProvider,
      AsyncValue<GetCourseDetailsModel?>
    >((ref) => GetCourseDetailsProvider(dioClient: DioClient()));

class GetCourseDetailsProvider
    extends StateNotifier<AsyncValue<GetCourseDetailsModel?>> {
  DioClient dioClient;

  GetCourseDetailsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getCoursesDetails(String courseId) async {
    /// --------------------- Set loading state ------------------------------
    state = const AsyncValue.loading();
    try {
      logger.d("Course Id : $courseId");
      final res = await dioClient.getHttp(
        ApiEndpoints.getCourseDetails(courseId),
      );

      if (res['success']) {
        logger.d("${res['success']}");
        final model = GetCourseDetailsModel.fromJson(res);
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          'Failed to load course details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error : $e");
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// ------------------------ Enroll Personal Info Provider ---------------------

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
final dobControllerProvider = StateProvider<TextEditingController>(
  (ref) => TextEditingController(),
);

final experienceLevelProvider = StateProvider<String>((ref) => '');
final experienceControllerProvider = StateProvider<TextEditingController>(
  (ref) => TextEditingController(),
);

final enrollPersonalInfoProvider =
    StateNotifierProvider<EnrollPersonalInfoProvider, EnrollPersonalInfoModel>(
      (ref) => EnrollPersonalInfoProvider(dioClient: DioClient()),
    );

class EnrollPersonalInfoProvider
    extends StateNotifier<EnrollPersonalInfoModel> {
  DioClient dioClient;

  EnrollPersonalInfoProvider({required this.dioClient})
    : super(EnrollPersonalInfoModel());

  Future<EnrollPersonalInfoModel> postEnrollPersonalInfo({
    required String courseType,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required String dateOfBirth,
    required String experienceLevel,
    required String actingGoals,
    required String enrollmentId,
  }) async {
    var body = {
      'course_type': courseType,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth,
      'experience_level': experienceLevel,
      'acting_goals': actingGoals,
    };
    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.enrollPersonalInfo(enrollmentId),
        body,
      );
      if (res['success']) {
        return EnrollPersonalInfoModel.fromJson(res);
      } else {
        return EnrollPersonalInfoModel(success: false, message: res['message']);
      }
    } catch (e) {
      return EnrollPersonalInfoModel(success: false, message: "$e");
    }
  }
}

/// ------------------------ Accept Rules-Regulations --------------------------

final acknowledgeProvider = StateProvider<bool>((ref) => false);
final acceptRulesRegulationsProvider =
    StateNotifierProvider<AcceptRulesRegulationsProvider, ResponseModel>(
      (ref) => AcceptRulesRegulationsProvider(dioClient: DioClient()),
    );

class AcceptRulesRegulationsProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  AcceptRulesRegulationsProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  Future<ResponseModel> acceptRulesRegulations({
    required bool accepted,
    required String fullName,
    required String digitalSignature,
    required String digitalSignatureDate,
    required String enrollmentId,
  }) async {
    try {
      var body = {
        'accepted': accepted,
        'full_name': fullName,
        'digital_signature': digitalSignature,
        'digital_signature_date': digitalSignatureDate,
      };

      final res = await dioClient.postHttp(
        ApiEndpoints.acceptRulesRegulations(enrollmentId),
        body,
      );

      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: "$e");
    }
  }
}

/// -------------------------- Accept Contract Terms ---------------------------

final acceptContractTermsProvider =
    StateNotifierProvider<AcceptContractTermsProvider, ResponseModel>(
      (ref) => AcceptContractTermsProvider(dioClient: DioClient()),
    );

class AcceptContractTermsProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  AcceptContractTermsProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  Future<ResponseModel> acceptContractTerms({
    required bool accepted,
    required String fullName,
    required String digitalSignature,
    required String digitalSignatureDate,
    required String enrollmentId,
  }) async {
    var body = {
      'accepted': accepted,
      'full_name': fullName,
      'digital_signature': digitalSignature,
      'digital_signature_date': digitalSignatureDate,
    };
    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.acceptContractTerms(enrollmentId),
        body,
      );
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: "$e");
    }
  }
}

/// ------------------------ Create Payment Intent -----------------------------

class CreatePaymentIntentProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  CreatePaymentIntentProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  Future<ResponseModel> createPaymentIntent({
    required String enrollmentId,
    required String paymentType,
    required String currency,
  }) async {
    var body = {
      'enrollmentId': enrollmentId,
      'payment_type': paymentType,
      'currency': currency,
    };

    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.createPaymentIntent,
        body,
      );

      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }
}
