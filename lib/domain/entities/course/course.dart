import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final bool highlighted;

  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    this.highlighted = false,
  });

  Course copyWith({bool? highlighted}) => Course(
    id: id,
    title: title,
    subtitle: subtitle,
    highlighted: highlighted ?? this.highlighted,
  );

  @override
  List<Object?> get props => [id, title, subtitle, highlighted];
}
