import '../../models/course/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> fetchCourses();
}
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  @override
  Future<List<CourseModel>> fetchCourses() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return [
      CourseModel(
        id: '1',
        title: '2 year program ( adult )',
        subtitle: '1-day weekend lessons, 4 modules.',
      ),
      CourseModel(
        id: '2',
        title: '2 year program ( Kids )',
        subtitle: '1-day weekend lessons, 4 modules.',
        highlighted: true, // the blue-outlined one
      ),
      CourseModel(
        id: '3',
        title: 'Full package ( Kids )',
        subtitle: '1-day weekend lessons, 4 modules.',
      ),
      CourseModel(
        id: '4',
        title: 'Full package ( adults )',
        subtitle: '1-day weekend lessons, 4 modules.',
      ),
    ];
  }
}
