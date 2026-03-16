import 'package:abbas/presentation/views/course_screen/screens/my_course/widget/course_widget.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_course/widget/my_assignment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/secondary_appber.dart';

class MyCourseScreen extends StatefulWidget {
  final String courseId;

  const MyCourseScreen({super.key, required this.courseId});

  @override
  State<MyCourseScreen> createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF030D15),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecondaryAppBar(title: "My Course"),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: const Color(0xFF030D15),
                    child: TabBar(
                      tabAlignment: TabAlignment.fill,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.red, width: 3.0),
                        ),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      labelStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 16.sp),
                      tabs: const [
                        Tab(text: "Course"),
                        Tab(text: "Assignment"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CourseWidget(courseId: widget.courseId),
                        MyAssignmentWidget(courseId: widget.courseId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
