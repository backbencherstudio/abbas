import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cors/routes/route_names.dart';
import '../model/enrollment_args.dart';
import '../view_model/form_fill_and_rules_provider.dart';

class EnrollmentNavigator {
  static Future<void> navigateToCurrentStep(
    BuildContext context,
    WidgetRef ref, {
    required String courseId,
    bool replace = false,
  }) async {
    await ref.read(currentStepProvider.notifier).currentStep(courseId: courseId);

    final stepState = ref.read(currentStepProvider);
    final stepModel = stepState.maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    final currentStep = stepModel?.data?.currentStep ?? 'FORM_FILLING';
    final enrollmentId = stepModel?.data?.enrollmentId ?? '';

    if (!context.mounted) return;

    _navigate(
      context,
      courseId: courseId,
      enrollmentId: enrollmentId,
      currentStep: currentStep,
      replace: replace,
    );
  }

  static void _navigate(
    BuildContext context, {
    required String courseId,
    required String enrollmentId,
    required String currentStep,
    required bool replace,
  }) {
    void go(String route, Object? arguments) {
      if (replace) {
        Navigator.pushReplacementNamed(context, route, arguments: arguments);
      } else {
        Navigator.pushNamed(context, route, arguments: arguments);
      }
    }

    switch (currentStep) {
      case 'RULES_SIGNING':
        go(
          RouteNames.rulesRegulations,
          EnrollmentArgs(courseId: courseId, enrollmentId: enrollmentId),
        );
        break;
      case 'CONTRACT_SIGNING':
        go(
          RouteNames.digitalContractSigning,
          EnrollmentArgs(courseId: courseId, enrollmentId: enrollmentId),
        );
        break;
      case 'PAYMENT':
        go(RouteNames.payment, enrollmentId.isNotEmpty ? enrollmentId : courseId);
        break;
      case 'COMPLETED':
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.parentScreen,
          (route) => false,
        );
        break;
      case 'FORM_FILLING':
      default:
        if (!replace) {
          go(RouteNames.fillEnrollmentForm, courseId);
        }
        break;
    }
  }
}
