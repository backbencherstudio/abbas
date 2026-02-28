import 'package:flutter/foundation.dart';
import '../../../domain/entities/course/course.dart';
import '../../../domain/usecases/course/get_courses.dart';

class CourseViewModel extends ChangeNotifier {
  final GetCourses? _getCourses;
  CourseViewModel(this._getCourses);
  List<Course> _courses = [];
  List<Course> get courses => _courses;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _courses = await _getCourses!();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void toggleHighlight(String id) {
    _courses = _courses
        .map((c) => c.id == id ? c.copyWith(highlighted: !c.highlighted) : c)
        .toList();
    notifyListeners();
  }
}
