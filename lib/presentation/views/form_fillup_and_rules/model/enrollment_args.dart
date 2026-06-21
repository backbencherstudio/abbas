class EnrollmentArgs {
  final String courseId;
  final String enrollmentId;

  const EnrollmentArgs({
    required this.courseId,
    required this.enrollmentId,
  });

  Map<String, String> toMap() => {
        'courseId': courseId,
        'enrollmentId': enrollmentId,
      };

  factory EnrollmentArgs.fromArguments(Object? args) {
    if (args is EnrollmentArgs) return args;
    if (args is Map) {
      return EnrollmentArgs(
        courseId: (args['courseId'] ?? '').toString(),
        enrollmentId: (args['enrollmentId'] ?? args['enrollment_id'] ?? '')
            .toString(),
      );
    }
    if (args is String && args.isNotEmpty) {
      return EnrollmentArgs(courseId: '', enrollmentId: args);
    }
    return const EnrollmentArgs(courseId: '', enrollmentId: '');
  }
}
