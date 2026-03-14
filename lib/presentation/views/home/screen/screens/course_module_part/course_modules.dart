import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/secondary_appber.dart';

class CourseModules extends StatelessWidget {
  const CourseModules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecondaryAppBar(title: 'Course Module'),
            SizedBox(height: 23),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "1 year program ( adult)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Color(0xff1C2C41),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Course Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "This course consists of a 2-year period trajectory that runs 1 day a week on Sunday takes place.",
                      style: TextStyle(
                        color: Color(0xffD2D2D5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Color(0xff1C2C41),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Course Module",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "The lessons consist of 4 modules:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Module 1: Personal development",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Module 2: Script Analysis",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Module 3: Meisner",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Module 4: Auditioning",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "In additional to the lessons, this package also include:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "A certificate of the training completed",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "1 scene that you can add to your portfolio\n access to casting platform Spotlight",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Color(0xff1C2C41),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Course Fee: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$1200",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Installment Process:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "One time",
                      style: TextStyle(color: Color(0xff8D9CDC)),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "You pay the full amount at once.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "No recurring payments or extra charges.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Text(
                      "Monthly Installments",
                      style: TextStyle(color: Color(0xff8D9CDC)),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "You pay the total amount in smaller,\nrecurring monthly payments.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Extra charges may apply, as noted by the\n line: “Monthly plans include extra charges.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xff1C2C41),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/icons/instructor.png"),
                        SizedBox(width: 10.w),
                        Text(
                          "Instructor",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/icons/no_image.png",
                          fit: BoxFit.cover, // makes it fill nicely
                          width: 40, // optional, control size
                          height: 40,
                        ),
                      ),

                      title: Text(
                        "Sophie Lambert",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "20+ years experience in theather and filem.Trained at Royal Academy of Dramatic Art",
                        style: TextStyle(
                          color: Color(0xffD2D2D5),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.center,
              child: PrimaryButton(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.myCourse);
                },
                color: Color(0xFFE9201D),
                textColor: Colors.white,
                icon: '',
                child: Text("Enroll Now"),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
