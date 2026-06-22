import 'due_assignment_screen.dart';

/// Uses the same unified assignment details screen.
class SubmittedAssignmentScreen extends DueAssignmentScreen {
  const SubmittedAssignmentScreen({
    super.key,
    required String assignmentId,
  }) : super(assignmentId: assignmentId);
}
