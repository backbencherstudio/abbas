import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../widgets/custom_appbar.dart';
import '../widget/filter_widget.dart';
import '../provider/create_chat_provider.dart';
import '../model/all_conversation_model.dart';

class MessageScreens extends StatefulWidget {
  const MessageScreens({super.key});

  @override
  State<MessageScreens> createState() => _MessageScreensState();
}

class _MessageScreensState extends State<MessageScreens> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<CreateChatProvider>();
    final data = chatProvider.allConversationModel as List<AllConversationModel>? ?? [];

    // Filter conversations
    final filteredData = data.where((conv) {
      switch (selectedFilter) {
        case 'All':
          return true;
        case 'Group':
          return conv.type?.toUpperCase() == 'GROUP';
        case 'DM':
          return conv.type?.toUpperCase() == 'DM';
        default:
          return true;
      }
    }).toList();
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      fillColor: const Color(0xff030D15),
                      hintText: "Search message...",
                      hintStyle: const TextStyle(color: Color(0xff3D4566)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
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
          ),
          SizedBox(
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Group', 'DM'].map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff1F283D), width: 2),
                        borderRadius: BorderRadius.circular(50),
                        color: isSelected ? const Color(0xffE9201D) : Colors.transparent,
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final conv = filteredData[index];
                final isGroup = conv.type?.toUpperCase() == 'GROUP';
                final name = isGroup
                    ? conv.title ?? "Group"
                    : conv.receiverTitle ?? "User";
                final avatar = isGroup
                    ? "assets/images/group.png"
                    : conv.otherUserAvatar ?? "assets/images/user1.png";
                final lastMessage = conv.messages.isNotEmpty
                    ? conv.messages.last.text ?? ""
                    : "No messages yet";
                final time = conv.messages.isNotEmpty
                    ? conv.messages.last.createdAt?.split("T").last.split(".").first ?? ""
                    : "";

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.oneTwoOneChatScreen,
                      arguments: conv,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                avatar,
                                height: 40.h,
                                width: 40.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                    "assets/images/user1.png",
                                    height: 40.h,
                                    width: 40.w),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: const TextStyle(color: Colors.white)),
                                  Text(lastMessage,
                                      style: const TextStyle(color: Color(0xff8C9196))),
                                ],
                              ),
                            ),
                            Text(time, style: const TextStyle(color: Color(0xff8C9196))),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: const Color(0xff121D2D)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}