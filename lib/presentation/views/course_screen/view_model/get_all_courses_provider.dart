import 'package:abbas/presentation/views/course_screen/model/get_my_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/model/my_courses_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/network/api_error_handle.dart';
import '../../../../cors/services/dio_client.dart';
import '../model/get_all_courses_model.dart';
import '../model/get_course_details_model.dart';

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

/// ------------------------- My Course ----------------------------------------
final myCourseProvider =
    StateNotifierProvider<MyCourseProvider, AsyncValue<MyCoursesModel?>>(
      (ref) => MyCourseProvider(dioClient: DioClient()),
    );

class MyCourseProvider extends StateNotifier<AsyncValue<MyCoursesModel?>> {
  DioClient dioClient;

  MyCourseProvider({required this.dioClient}) : super(AsyncValue.data(null));

  Future<void> getMyCourse() async {
    state = const AsyncLoading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getMyCourses);
      if (res['success']) {
        logger.d("${res['success']}");
        final model = MyCoursesModel.fromJson(res);
        state = AsyncData(model);
      } else {
        state = AsyncError('Failed to load course', StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error : $e");
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}

/// ------------------------- Get My Assignments -------------------------------
class GetMyAssignmentsProvider
    extends StateNotifier<AsyncValue<GetMyAssignmentsModel?>> {
  DioClient dioClient;

  GetMyAssignmentsProvider({required this.dioClient}) : super(AsyncData(null));

  Future<void> getMyAssignments({required String courseId}) async {
    state = const AsyncLoading();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getMyAssignments(courseId));
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
