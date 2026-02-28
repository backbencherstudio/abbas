import '../../../domain/entities/course/course.dart';
import '../../../domain/repositories/course/course_repository.dart';
import '../../datasources/course/course_remote.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remote;
  CourseRepositoryImpl(this.remote);

  @override
  Future<List<Course>> getCourses() async {
    final models = await remote.fetchCourses();
    return models.map((m) => m.toEntity()).toList();
  }
}
