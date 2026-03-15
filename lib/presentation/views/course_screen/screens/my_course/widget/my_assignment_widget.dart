import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';

class MyAssignmentWidget extends ConsumerStatefulWidget {
  final String courseId;

  const MyAssignmentWidget({super.key, required this.courseId});

  @override
  ConsumerState<MyAssignmentWidget> createState() => _MyAssignmentWidgetState();
}

class _MyAssignmentWidgetState extends ConsumerState<MyAssignmentWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getMyAssignmentsProvider.notifier)
          .getMyAssignments(courseId: widget.courseId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsProvider = ref.watch(getMyAssignmentsProvider);
    return assignmentsProvider.when(
      loading: () => const CircularProgressIndicator(color: Colors.white),
      error: (err, stackTrace) => Center(child: Text("Error : $err")),
      data: (data) {
        final assignmentsData = data;
        final modules = assignmentsData?.data;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...modules!.map((value) {
                  return Text(
                    "${value.moduleTitle} : ${value.moduleName}",
                    style: TextStyle(
                      color: Color(0xff8C9196),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),

                SizedBox(height: 10),
                ...modules.map((assign) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: assign.assignments?.length,
                      itemBuilder: (context, index) {
                        final value = assign.assignments![index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3),
                              ),
                              color: Color(0xff061220),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  value.title ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffF9C80E),
                                  ),
                                  child: Text(
                                    value.dueLabel ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.dueAssignmentScreen,
                                      arguments: value.id
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                Text(
                  "Module 1 : Personal Development",
                  style: TextStyle(color: Color(0xff8C9196)),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteNames.submittedAssignmentScreen,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3),
                              ),
                              color: Color(0xff061220),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Assignment ${index + 4}",
                                  // Dynamically showing the assignment number
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xff1E273D),
                                  ),
                                  child: Text(
                                    "Submitted",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xff1E273D),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Grade: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "A+",
                                        style: TextStyle(
                                          color: AppColors.radishTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
