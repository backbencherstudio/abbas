// import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// void filterBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
//     ),
//     builder: (BuildContext context) {
//       return Container(
//         color: Color(0xff07121D),
//         width: double.infinity,
//         padding: EdgeInsets.all(16.r),
//         height: 500.h,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with title and close icon
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Filter",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context); // Close the bottom sheet
//                   },
//                 ),
//               ],
//             ),
//             Divider(thickness: 0.7, color: Color(0xff121D2D)),
//             // Status Filter
//             Text("Status", style: TextStyle(color: Colors.white)),
//             Column(
//               children: [
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     "Unread Only",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   leading: Radio<String>(
//                     value: 'all',
//                     groupValue: context.watch<CreateChatProvider>().statusValue,
//                     onChanged: (value) {
//                       context.read<CreateChatProvider>().toggleStatus(value!);
//                     },
//                   ),
//                 ),
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     "Read messages",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   leading: Radio<String>(
//                     value: 'active',
//                     groupValue: context.watch<CreateChatProvider>().statusValue,
//                     onChanged: (value) {
//                       context.read<CreateChatProvider>().toggleStatus(value!);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Divider(thickness: 0.7, color: Color(0xff121D2D)),
//             // Date Filter
//             Text("Date", style: TextStyle(color: Colors.white)),
//             Column(
//               children: [
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     "Last 24 hours",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   leading: Radio<String>(
//                     value: 'today',
//                     groupValue: context.watch<CreateChatProvider>().dateValue,
//                     onChanged: (value) {
//                       context.read<CreateChatProvider>().toggleDate(value!);
//                     },
//                   ),
//                 ),
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     "Last 47 days",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   leading: Radio<String>(
//                     value: 'yesterday',
//                     groupValue: context.watch<CreateChatProvider>().dateValue,
//                     onChanged: (value) {
//                       context.read<CreateChatProvider>().toggleDate(value!);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       backgroundColor: Colors.transparent,
//
//                       side: BorderSide(color: Color(0xff3D4566)),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       "Clear",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       backgroundColor: Colors.white,
//
//                       side: BorderSide(color: Colors.white),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       "Apply",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
