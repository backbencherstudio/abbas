import 'dart:io';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_assignment_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_class_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_course_assets_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_module_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_my_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/model/my_course_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/my_courses_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/network/api_error_handle.dart';
import '../../../../cors/services/dio_client.dart';
import '../model/get_all_courses_model.dart';
import '../model/get_course_details_model.dart';

/// ------------------ Submit Assignment ---------------------------------------

final selectedFileProvider = StateProvider<File?>((ref) => null);
final submitAssignmentLoadingProvider = StateProvider<bool>((ref) => false);
final submitAssignmentProvider =
    StateNotifierProvider<SubmitAssignmentProvider, ResponseModel>(
      (ref) => SubmitAssignmentProvider(dioClient: DioClient()),
    );

class SubmitAssignmentProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  SubmitAssignmentProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  Future<ResponseModel> submitAssignment({
    required String title,
    required String description,
    required File media,
    required String assignmentId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "title": title,
        "description": description,

        "media": await MultipartFile.fromFile(
          media.path,
          filename: media.path.split('/').last,
        ),
      });

      final response = await dioClient.postHttp(
        ApiEndpoints.submitAssignment(assignmentId),
        formData,
      );

      if (response is ResponseModel) {
        return response;
      }

      if (response['success']) {
        return ResponseModel(success: true, message: response['message']);
      } else {
        return ResponseModel(success: false, message: response['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: e.toString());
    }
  }
}

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

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

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

/// ------------------------- My Course ----------------------------------------
final myCourseProvider =
    StateNotifierProvider<MyCourseProvider, AsyncValue<MyCoursesModel?>>(
      (ref) => MyCourseProvider(dioClient: DioClient()),
    );

class MyCourseProvider extends StateNotifier<AsyncValue<MyCoursesModel?>> {
  final DioClient dioClient;

  MyCourseProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getMyCourse() async {
    state = const AsyncLoading();

    try {
      final res = await dioClient.getHttp(ApiEndpoints.getMyCourses);

      if (res is ResponseModel) {
        state = AsyncError(res.message, StackTrace.current);
        return;
      }

      if (res['success'] == true) {
        final data = MyCoursesModel.fromJson(res);

        state = AsyncData(data);
      } else {
        state = AsyncError("Failed to load courses", StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error: $e");
      state = AsyncError(e, stackTrace);
    }
  }
}

/// ----------------- My course Details ----------------------------------------
final myCourseDetailsProvider =
    StateNotifierProvider<
      MyCourseDetailsProvider,
      AsyncValue<MyCourseDetailsModel?>
    >((ref) => MyCourseDetailsProvider(dioClient: DioClient()));

class MyCourseDetailsProvider
    extends StateNotifier<AsyncValue<MyCourseDetailsModel?>> {
  DioClient dioClient;

  MyCourseDetailsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> myCourseDetails({required String courseId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.myCourseDetails(courseId),
      );

      if (res is ResponseModel) {
        state = AsyncError(res.message, StackTrace.current);
        return;
      }

      if (res['success']) {
        final model = MyCourseDetailsModel.fromJson(res);
        state = AsyncValue.data(model);
      } else {
        state = AsyncError(
          'Failed to load courses details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      logger.e("Load course details error $e");
      state = AsyncError(e, stackTrace);
    }
  }
}

/// ------------------------- Get Module Details -------------------------------

final getModuleDetailsProvider =
    StateNotifierProvider<
      GetModuleDetailsProvider,
      AsyncValue<GetModuleDetailsModel?>
    >((ref) => GetModuleDetailsProvider(dioClient: DioClient()));

class GetModuleDetailsProvider
    extends StateNotifier<AsyncValue<GetModuleDetailsModel?>> {
  DioClient dioClient;

  GetModuleDetailsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getModuleDetails({required String moduleId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getModuleDetails(moduleId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success']) {
        final model = GetModuleDetailsModel.fromJson(res);
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          'Failed to load Module Details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// -------------------------- Get class Details -------------------------------
final getClassDetailsProvider =
    StateNotifierProvider<
      GetClassDetailsProvider,
      AsyncValue<GetClassDetailsModel?>
    >((ref) => GetClassDetailsProvider(dioClient: DioClient()));

class GetClassDetailsProvider
    extends StateNotifier<AsyncValue<GetClassDetailsModel?>> {
  DioClient dioClient;

  GetClassDetailsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<bool?> getClassDetails({required String classId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getClassDetails(classId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return false;
      }

      if (res['success']) {
        final model = GetClassDetailsModel.fromJson(res);
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error("Load to class details", StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Error to load data $e");
      state = AsyncValue.error(e, stackTrace);
    }
    return null;
  }
}

/// ------------------------- Get My Assignments -------------------------------

final getMyAssignmentsProvider =
    StateNotifierProvider<
      GetMyAssignmentsProvider,
      AsyncValue<GetMyAssignmentsModel?>
    >((ref) => GetMyAssignmentsProvider(dioClient: DioClient()));

class GetMyAssignmentsProvider
    extends StateNotifier<AsyncValue<GetMyAssignmentsModel?>> {
  DioClient dioClient;

  GetMyAssignmentsProvider({required this.dioClient}) : super(const AsyncData(null));

  Future<void> getMyAssignments({required String courseId}) async {
    state = const AsyncLoading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getMyAssignments(courseId),
      );

      if (res is ResponseModel) {
        state = AsyncError(res.message, StackTrace.current);
        return;
      }

      if (res['success']) {
        logger.d("${res['success']}");
        final model = GetMyAssignmentsModel.fromJson(res);
        state = AsyncData(model);
      } else {
        state = AsyncError('Failed to load assignments', StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error : $e");
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}

/// ----------------------- Get Assignment Details -----------------------------

final getAssignmentDetailsProvider =
    StateNotifierProvider<
      GetAssignmentDetailsProvider,
      AsyncValue<GetAssignmentDetailsModel?>
    >((ref) => GetAssignmentDetailsProvider(dioClient: DioClient()));

class GetAssignmentDetailsProvider
    extends StateNotifier<AsyncValue<GetAssignmentDetailsModel?>> {
  DioClient dioClient;

  GetAssignmentDetailsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getAssignmentDetails({required String assignmentId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getAssignmentDetails(assignmentId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success']) {
        final model = GetAssignmentDetailsModel.fromJson(res);
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error('Load to fail data', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// --------------------- Get Course Assets ------------------------------------
final getCourseAssetsProvider =
    StateNotifierProvider<
      GetCourseAssetsProvider,
      AsyncValue<GetCourseAssetsModel?>
    >((ref) => GetCourseAssetsProvider(dioClient: DioClient()));

class GetCourseAssetsProvider
    extends StateNotifier<AsyncValue<GetCourseAssetsModel?>> {
  DioClient dioClient;

  GetCourseAssetsProvider({required this.dioClient})
    : super(const AsyncValue.loading());

  Future<void> getCourseAssets({required String courseId}) async {
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getCourseAssets(courseId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      final model = GetCourseAssetsModel.fromJson(res);
      state = AsyncValue.data(model);
    } catch (e, stackTrace) {
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

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

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
