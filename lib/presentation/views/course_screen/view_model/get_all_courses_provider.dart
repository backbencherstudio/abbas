import 'package:abbas/presentation/views/course_screen/model/get_class_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_module_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_my_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/model/my_course_details_model.dart';
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
  final DioClient dioClient;

  MyCourseProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getMyCourse() async {
    state = const AsyncLoading();

    try {
      final res = await dioClient.getHttp(ApiEndpoints.getMyCourses);

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
    : super(AsyncValue.data(null));

  Future<void> myCourseDetails({required String courseId}) async {
    state = AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.myCourseDetails(courseId),
      );
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
    : super(AsyncValue.data(null));

  Future<void> getModuleDetails({required String moduleId}) async {
    state = AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getModuleDetails(moduleId),
      );
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
    : super(AsyncValue.data(null));

  Future<void> getClassDetails({required String classId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getClassDetails(classId),
      );
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
  }
}

/// ------------------------- Get My Assignments -------------------------------

final getMyAssignmentsProvider =
    StateNotifierProvider<GetMyAssignmentsProvider, AsyncValue<GetMyAssignmentsModel?>>(
      (ref) => GetMyAssignmentsProvider(dioClient: DioClient()),
    );

class GetMyAssignmentsProvider
    extends StateNotifier<AsyncValue<GetMyAssignmentsModel?>> {
  DioClient dioClient;

  GetMyAssignmentsProvider({required this.dioClient}) : super(AsyncData(null));

  Future<void> getMyAssignments({required String courseId}) async {
    state = const AsyncLoading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getMyAssignments(courseId),
      );
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
