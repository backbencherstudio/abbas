import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';

class MyAssignmentWidget extends StatelessWidget {
  const MyAssignmentWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Module 2 : Script Analysis",
              style: TextStyle(
                color: Color(0xff8C9196),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.myAssignmentScreen,
                        );
                      },
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
                              "Assignment ${index + 6}",
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
                              child: Text("Due 2 days", style: TextStyle(color: Colors.black, fontSize: 12),),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: (){Navigator.pushNamed(context, RouteNames.myAssignmentScreen);}, icon: Icon( Icons.arrow_forward_ios,),

                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

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
                      onTap: () => Navigator.pushNamed(context, RouteNames.submittedAssignmentScreen),
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
                              "Assignment ${index + 4}", // Dynamically showing the assignment number
                              style: TextStyle(color: Colors.white, fontSize: 16),
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
                                style: TextStyle(color: Colors.white, fontSize: 12),
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
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    "A+",
                                    style: TextStyle(color: AppColors.radishTextColor, fontSize: 12),
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
  }
}
