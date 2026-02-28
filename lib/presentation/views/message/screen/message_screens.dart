import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../widgets/custom_appbar.dart';
import '../widget/filter_widget.dart';

class MessageScreens extends StatefulWidget {
  const MessageScreens({super.key});

  @override
  State<MessageScreens> createState() => _MessageScreensState();
}

class _MessageScreensState extends State<MessageScreens> {
  String selectedFilter = 'All';

  final Map<String, List<Map<String, String>>> messageData = {
    'All': [
      {
        'name': 'Cameron Williamson',
        'message': 'Thanks, For the suggestions.',
        'time': '10:32 AM',
      },
      {
        'name': 'Cameron Williamson',
        'message': 'Thanks, For the suggestions.',
        'time': '10:32 AM',
      },
      {
        'name': 'Cameron Williamson',
        'message': 'Thanks, For the suggestions.',
        'time': '10:32 AM',
      },
      {
        'name': 'Cameron Williamson',
        'message': 'Thanks, For the suggestions.',
        'time': '10:32 AM',
      },
      {
        'name': 'Cameron Williamson',
        'message': 'Thanks, For the suggestions.',
        'time': '10:32 AM',
      },
      {'name': 'Jane Doe', 'message': 'Meeting at 2 PM.', 'time': '10:30 AM'},
      {
        'name': 'John Smith',
        'message': 'Review completed.',
        'time': '10:28 AM',
      },
      {
        'name': 'Alice Johnson',
        'message': 'Urgent: Call me.',
        'time': '10:25 AM',
      },
    ],
    'Group': [
      {
        'name': 'Group Chat 1',
        'message': 'Group meeting tomorrow.',
        'time': '10:32 AM',
      },
      {
        'name': 'Group Chat 2',
        'message': 'Update on project.',
        'time': '10:30 AM',
      },
    ],
    'Teacher': [
      {
        'name': 'Jane Doe',
        'message': 'Assignment due today.',
        'time': '10:32 AM',
      },
      {'name': 'John Smith', 'message': 'Class canceled.', 'time': '10:28 AM'},
    ],
    'Admin': [
      {
        'name': 'Alice Johnson',
        'message': 'System update scheduled.',
        'time': '10:32 AM',
      },
      {'name': 'Bob Wilson', 'message': 'Access granted.', 'time': '10:25 AM'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredMessages = messageData[selectedFilter]!;

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          CustomAppbar(
            title: "Message",
            image: "assets/icons/edit.png",
            onTap: () {
              Navigator.pushNamed(context, RouteNames.newMessageScreens);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              fillColor: const Color(0xff030D15),
                              hintText: "Search message...",
                              hintStyle: const TextStyle(
                                color: Color(0xff3D4566),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(99),
                                borderSide: const BorderSide(
                                  color: Color(0xff3D4566),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(99),
                                borderSide: const BorderSide(
                                  color: Color(0xff3D4566),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(99),
                                borderSide: const BorderSide(
                                  color: Color(0xff3D4566),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 13.w),
                        GestureDetector(
                          onTap: () {
                            filterBottomSheet(context);
                          },
                          child: Image.asset(
                            "assets/icons/filter.png",
                            height: 30.h,
                            width: 30.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        itemCount: ['All', 'Group', 'Teacher', 'Admin'].length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final filter = [
                            'All',
                            'Group',
                            'Teacher',
                            'Admin',
                          ][index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff1F283D),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: selectedFilter == filter
                                      ? const Color(0xffE9201D)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    color: selectedFilter == filter
                                        ? Colors.white
                                        : const Color(0xffFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ListView.builder(
                      itemCount: filteredMessages.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final message = filteredMessages[index];
                        return GestureDetector(
                          onTap: () {
                            if(selectedFilter == "Group"){
                              Navigator.pushNamed(
                                context,
                                RouteNames.oneTwoOneChatScreen,
                              );
                            }else{
                              Navigator.pushNamed(
                                context,
                                RouteNames.oneTwoOneChatScreen,
                              );

                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: const BoxDecoration(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(

                                      onTap: () {
                                        if(selectedFilter == "Group"){
                                          Navigator.pushNamed(
                                            context,
                                            RouteNames.groupProfileScreen,
                                          );
                                        }else{
                                          Navigator.pushNamed(
                                            context,
                                            RouteNames.userProfileScreen,
                                          );

                                        }

                                      },
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/images/user1.png",
                                          height: 40.h,
                                          width: 40.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message['name']!,
                                            style: const TextStyle(
                                              color: Color(0xffFFFFFF),
                                            ),
                                          ),
                                          Text(
                                            message['message']!,
                                            style: const TextStyle(
                                              color: Color(0xff8C9196),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      message['time']!,
                                      style: const TextStyle(
                                        color: Color(0xff8C9196),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Divider(color: Color(0xff121D2D)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
