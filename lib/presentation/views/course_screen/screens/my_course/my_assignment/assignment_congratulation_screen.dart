import 'package:flutter/material.dart';

class AssignmentCongratulationScreen extends StatefulWidget {
  final String assignmentId;

  const AssignmentCongratulationScreen({super.key, required this.assignmentId});

  @override
  State<AssignmentCongratulationScreen> createState() =>
      _AssignmentCongratulationScreenState();
}

class _AssignmentCongratulationScreenState
    extends State<AssignmentCongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Congratulation")));
  }
}
