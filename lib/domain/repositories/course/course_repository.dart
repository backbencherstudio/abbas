import '../../entities/course/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
}
