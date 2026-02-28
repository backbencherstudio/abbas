import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/secondary_appber.dart';

class AddGroupMember extends StatelessWidget {
  const AddGroupMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Add  Member"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff3D4566),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff3D4566),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff3D4566),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Text("Suggested", style: TextStyle(color: Color(0xffB2B5B8))),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, child) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              "https://i.pravatar.cc/150?img=13",
                              height: 50,
                              width: 50,
                            ),
                          ),
                          SizedBox(width: 14),
                          Text("Mohammad Wahab Reja"),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xff3D4566),
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
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
