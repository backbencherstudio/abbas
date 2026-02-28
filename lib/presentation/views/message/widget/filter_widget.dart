import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void filterBottomSheet(BuildContext context) {
  String? statusValue = 'all';
  String? dateValue = 'today';
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext context) {
      return Container(
        color: Color(0xff07121D),
        width: double.infinity,
        padding: EdgeInsets.all(16),
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ],
            ),
            Divider(thickness: 0.7, color: Color(0xff121D2D)),
            // Status Filter
            Text("Status", style: TextStyle(color: Colors.white)),
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Unread Only",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Radio<String>(
                    value: 'all',
                    groupValue: statusValue,
                    onChanged: (value) {
                      statusValue = value;
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Read messages",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Radio<String>(
                    value: 'active',
                    groupValue: statusValue,
                    onChanged: (value) {
                      statusValue = value;
                    },
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.7, color: Color(0xff121D2D)),
            // Date Filter
            Text("Date", style: TextStyle(color: Colors.white)),
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Last 24 hours",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Radio<String>(
                    value: 'today',
                    groupValue: dateValue,
                    onChanged: (value) {
                      dateValue = value;
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Last 47 days",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Radio<String>(
                    value: 'yesterday',
                    groupValue: dateValue,
                    onChanged: (value) {
                      dateValue = value;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent,

                      side: BorderSide(color: Color(0xff3D4566)),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,

                      side: BorderSide(color: Colors.white),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Apply",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
