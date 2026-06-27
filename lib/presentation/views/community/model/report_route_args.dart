class ReportRouteArgs {
  final String userId;
  final String reason;

  const ReportRouteArgs({
    required this.userId,
    required this.reason,
  });

  static ReportRouteArgs fromArguments(Object? args) {
    if (args is ReportRouteArgs) return args;
    if (args is Map) {
      return ReportRouteArgs(
        userId: args['userId']?.toString() ?? '',
        reason: args['reason']?.toString() ?? '',
      );
    }
    return const ReportRouteArgs(userId: '', reason: '');
  }
}
