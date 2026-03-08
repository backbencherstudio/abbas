import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/get_all_courses_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/get_course_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// ------------------ Get All Courses Provider --------------------------------
final getAllCoursesProvider =
    StateNotifierProvider<GetAllCoursesProvider, AsyncValue<GetAllCoursesModel?>>(
      (ref) => GetAllCoursesProvider(dioClient: DioClient()),
    );

class GetAllCoursesProvider extends StateNotifier<AsyncValue<GetAllCoursesModel?>> {
  DioClient dioClient;

  GetAllCoursesProvider({required this.dioClient})
    : super(AsyncValue.data(null));


  Future<void> getAllCourses() async {
    try {
      state = const AsyncValue.loading();

      final res = await dioClient.getHttp(ApiEndpoints.getAllCourses);
      if (res['success']) {
        logger.d("${res['success']}");
        final model = GetAllCoursesModel.fromJson(res);
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
    try {
      /// --------------------- Set loading state ------------------------------
      state = const AsyncValue.loading();

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
