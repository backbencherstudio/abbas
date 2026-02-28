
import '../../../domain/entities/course/course.dart';

class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final bool highlighted;

  const CourseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.highlighted = false,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) => CourseModel(
    id: map['id'] as String,
    title: map['title'] as String,
    subtitle: map['subtitle'] as String,
    highlighted: (map['highlighted'] ?? false) as bool,
  );

  Course toEntity() =>
      Course(id: id, title: title, subtitle: subtitle, highlighted: highlighted);
}
