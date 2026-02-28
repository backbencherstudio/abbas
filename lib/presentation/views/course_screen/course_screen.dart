import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../cors/routes/route_names.dart';
import '../../viewmodels/course/course_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import 'widget/custom_card.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CourseViewModel>().load());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CourseViewModel>();
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(
            title: "Course",
            image: "assets/icons/search.png",
            image2: "assets/icons/notification.png",
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: Text(
                    "My Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27),
                  child: GestureDetector(
                    onTap: (){Navigator.pushNamed(context, RouteNames.myCourseScreen);},
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 19, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xff9A1E21), Color(0xff0A192A)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-1, 1),
                            color: Color(0xffE9201D),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/face.png'),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "1 year program (adult)",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "1-day weekend lessons, 4 modules",
                                  style: TextStyle(
                                    color: Color(0xffD2D2D5),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                Text(
                                  "Progress : 35%",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                LinearProgressIndicator(
                                  value: 0.35,
                                  minHeight: 10,
                                  backgroundColor: Color(0xff212D44),
                                  color: Color(0xffE9201D),
                                  borderRadius: BorderRadiusDirectional.circular(
                                    10.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: Text(
                    textAlign: TextAlign.left,
                    "All Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vm.courses.length,
                  itemBuilder: (_, i) {
                    final c = vm.courses[i];
                    return CourseCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      date: 'Weekend',
                      time: '1-day lessons',
                      dateIcon: Icons.calendar_today,
                      timeIcon: Icons.access_time,
                      click: (){},
                    );
                  },
                ),

                SizedBox(height: 12.h),

                Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Other Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vm.courses.length,
                  itemBuilder: (_, i) {
                    final c = vm.courses[i];
                    return CourseCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      date: 'Weekend',
                      time: '1-day lessons',
                      dateIcon: Icons.calendar_today,
                      timeIcon: Icons.access_time,
                      click: (){
                        Navigator.pushNamed(context, RouteNames.otherCourseScreen);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
