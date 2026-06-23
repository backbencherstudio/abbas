import 'dart:io';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/course_screen/model/class_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/model/class_assets_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_assignment_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_class_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/course_assets_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_module_details_model.dart';
import 'package:abbas/presentation/views/course_screen/model/get_my_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/model/my_course_details_model.dart';
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
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'attachments': await MultipartFile.fromFile(
          media.path,
          filename: media.path.split('/').last,
        ),
      });

      final response = await dioClient.postMultipart(
        ApiEndpoints.submitAssignment(assignmentId),
        formData,
      );

      if (response is ResponseModel) {
        return response;
      }

      if (response['success'] == true) {
        return ResponseModel(
          success: true,
          message: response['message']?.toString() ?? 'Submitted successfully',
        );
      }

      return ResponseModel(
        success: false,
        message: response['message']?.toString() ?? 'Submission failed',
      );
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

      if (res['success'] == true) {
        final model = GetAllCoursesModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        final message = res is Map ? (res['message'] ?? 'Failed to load courses') : 'Failed to load courses';
        state = AsyncValue.error(message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error : $e");
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// ------------------------- My Course ----------------------------------------
final myCourseProvider =
    StateNotifierProvider<MyCourseProvider, AsyncValue<GetAllCoursesModel?>>(
      (ref) => MyCourseProvider(dioClient: DioClient()),
    );

class MyCourseProvider extends StateNotifier<AsyncValue<GetAllCoursesModel?>> {
  final DioClient dioClient;

  MyCourseProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getMyCourse() async {
    state = const AsyncValue.loading();

    try {
      final res = await dioClient.getHttp(ApiEndpoints.getEnrolledCourses);

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success'] == true) {
        final model = GetAllCoursesModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        final message = res is Map
            ? (res['message'] ?? 'Failed to load courses')
            : 'Failed to load courses';
        state = AsyncValue.error(message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      logger.e("Load Data Error: $e");
      state = AsyncValue.error(e, stackTrace);
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

      if (res['success'] == true) {
        final model = MyCourseDetailsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncError(
          res['message']?.toString() ?? 'Failed to load course details',
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

      if (res['success'] == true) {
        final model = GetModuleDetailsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Failed to load module details',
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

      if (res['success'] == true) {
        final model = GetClassDetailsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Failed to load class details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      logger.e("Error to load data $e");
      state = AsyncValue.error(e, stackTrace);
    }
    return null;
  }
}

/// ------------------------- Get Class Assets ---------------------------------

final getClassAssetsProvider =
    StateNotifierProvider<
      GetClassAssetsProvider,
      AsyncValue<ClassAssetsModel?>
    >((ref) => GetClassAssetsProvider(dioClient: DioClient()));

class GetClassAssetsProvider
    extends StateNotifier<AsyncValue<ClassAssetsModel?>> {
  DioClient dioClient;

  GetClassAssetsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getClassAssets({required String classId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getClassAssets(classId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success'] == true) {
        final model = ClassAssetsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Failed to load assets',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// ------------------------- Get Class Assignments ----------------------------

final getClassAssignmentsProvider =
    StateNotifierProvider<
      GetClassAssignmentsProvider,
      AsyncValue<ClassAssignmentsModel?>
    >((ref) => GetClassAssignmentsProvider(dioClient: DioClient()));

class GetClassAssignmentsProvider
    extends StateNotifier<AsyncValue<ClassAssignmentsModel?>> {
  DioClient dioClient;

  GetClassAssignmentsProvider({required this.dioClient})
    : super(const AsyncValue.data(null));

  Future<void> getClassAssignments({required String classId}) async {
    state = const AsyncValue.loading();
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getClassAssignments(classId),
      );

      if (res is ResponseModel) {
        state = AsyncValue.error(res.message, StackTrace.current);
        return;
      }

      if (res['success'] == true) {
        final model = ClassAssignmentsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Failed to load assignments',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
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

      if (res['success'] == true) {
        final model = GetMyAssignmentsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncData(model);
      } else {
        state = AsyncError(
          res['message']?.toString() ?? 'Failed to load assignments',
          StackTrace.current,
        );
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

      if (res['success'] == true) {
        final model = GetAssignmentDetailsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        state = AsyncValue.data(model);
      } else {
        state = AsyncValue.error(
          res['message']?.toString() ?? 'Failed to load assignment details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

/// --------------------- Get Course Assets ------------------------------------

class CourseAssetsCombinedState {
  final AsyncValue<CourseAssetsModel?> videos;
  final AsyncValue<CourseAssetsModel?> files;

  const CourseAssetsCombinedState({
    required this.videos,
    required this.files,
  });

  CourseAssetsCombinedState copyWith({
    AsyncValue<CourseAssetsModel?>? videos,
    AsyncValue<CourseAssetsModel?>? files,
  }) {
    return CourseAssetsCombinedState(
      videos: videos ?? this.videos,
      files: files ?? this.files,
    );
  }
}

final getCourseAssetsProvider =
    StateNotifierProvider<GetCourseAssetsProvider, CourseAssetsCombinedState>(
      (ref) => GetCourseAssetsProvider(dioClient: DioClient()),
    );

class GetCourseAssetsProvider
    extends StateNotifier<CourseAssetsCombinedState> {
  DioClient dioClient;

  GetCourseAssetsProvider({required this.dioClient})
    : super(
        const CourseAssetsCombinedState(
          videos: AsyncValue.data(null),
          files: AsyncValue.data(null),
        ),
      );

  Future<void> loadCourseAssets({required String courseId}) async {
    state = state.copyWith(
      videos: const AsyncValue.loading(),
      files: const AsyncValue.loading(),
    );

    await Future.wait([
      _fetchAssets(courseId: courseId, type: 'VIDEO', isVideo: true),
      _fetchAssets(courseId: courseId, type: 'FILE', isVideo: false),
    ]);
  }

  Future<void> _fetchAssets({
    required String courseId,
    required String type,
    required bool isVideo,
  }) async {
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.getCourseAssets(courseId, type: type),
      );

      if (res is ResponseModel) {
        final error = AsyncValue<CourseAssetsModel?>.error(
          res.message,
          StackTrace.current,
        );
        state = isVideo
            ? state.copyWith(videos: error)
            : state.copyWith(files: error);
        return;
      }

      if (res['success'] == true) {
        final model = CourseAssetsModel.fromJson(
          Map<String, dynamic>.from(res as Map),
        );
        final data = AsyncValue.data(model);
        state = isVideo
            ? state.copyWith(videos: data)
            : state.copyWith(files: data);
      } else {
        final error = AsyncValue<CourseAssetsModel?>.error(
          res['message']?.toString() ?? 'Failed to load assets',
          StackTrace.current,
        );
        state = isVideo
            ? state.copyWith(videos: error)
            : state.copyWith(files: error);
      }
    } catch (e, stackTrace) {
      final error = AsyncValue<CourseAssetsModel?>.error(e, stackTrace);
      state = isVideo
          ? state.copyWith(videos: error)
          : state.copyWith(files: error);
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
