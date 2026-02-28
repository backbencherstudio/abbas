import '../../entities/course/course.dart';
import '../../repositories/course/course_repository.dart';

class GetCourses {
  final CourseRepository repo;
  GetCourses(this.repo);

  Future<List<Course>> call() => repo.getCourses();
}
