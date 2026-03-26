import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../widgets/custom_appbar.dart';
import '../provider/create_chat_provider.dart';
import '../model/all_conversation_model.dart';

class MessageScreens extends StatefulWidget {
  const MessageScreens({super.key});

  @override
  State<MessageScreens> createState() => _MessageScreensState();
}

class _MessageScreensState extends State<MessageScreens> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserAndConversations();
  }

  Future<void> _loadUserAndConversations() async {
    _currentUserId = await UserIdStorage().getUserId();

    if (mounted) {
      context.read<CreateChatProvider>().getAllConversation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateChatProvider>();
    final List<AllConversationModel> allConversations = provider.allConversationModel;

    // Filter Logic
    final filteredData = allConversations.where((conv) {
      final filter = provider.selectedFilter;
      if (filter == 'Group') return conv.type?.toUpperCase() == 'GROUP';
      if (filter == 'DM') return conv.type?.toUpperCase() == 'DM';
      return true; // All
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          // AppBar
          CustomAppbar(
            title: "Message",
            image: "assets/icons/edit.png",
            onTap: () => Navigator.pushNamed(context, RouteNames.newMessageScreens),
          ),

          // Search
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
                        borderSide: const BorderSide(color: Color(0xff3D4566)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: Color(0xff3D4566)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: Color(0xff3D4566)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 13.w),
              ],
            ),
          ),

          // Filter Tabs
          SizedBox(
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              children: ['All', 'Group', 'DM'].map((filter) {
                final isSelected = provider.selectedFilter == filter;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: GestureDetector(
                    onTap: () => provider.toggleFilter(filter),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff1F283D), width: 2),
                        borderRadius: BorderRadius.circular(50),
                        color: isSelected ? const Color(0xffE9201D) : Colors.transparent,
                      ),
                      child: Text(
                        filter,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 12.h),

          // Conversation List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredData.isEmpty
                ? const Center(
              child: Text(
                "No conversations found",
                style: TextStyle(color: Colors.white70),
              ),
            )
                : ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final conv = filteredData[index];
                final isGroup = conv.type?.toUpperCase() == "GROUP";

                // ================== Display Name ==================
                String displayName = "Unknown Chat";
                if (isGroup) {
                  displayName = conv.title?.trim() ?? "Group";
                } else {
                  if (_currentUserId != null && conv.creatorId == _currentUserId) {
                    displayName = conv.receiverTitle?.trim() ?? "Direct Message";
                  } else {
                    displayName = conv.senderTitle?.trim() ?? "Direct Message";
                  }
                }

                // ================== Last Message (Corrected according to your model) ==================
                String lastMsg = "No messages yet";
                if (conv.messages != null && conv.messages!.isNotEmpty) {
                  final last = conv.messages!.last;
                  lastMsg = last.content?.text?.trim() ?? "Attachment";
                }

                // ================== Time ==================
                String time = "";
                if (conv.messages != null &&
                    conv.messages!.isNotEmpty &&
                    conv.messages!.last.createdAt != null) {
                  final dt = DateTime.tryParse(conv.messages!.last.createdAt!);
                  if (dt != null) {
                    time = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                  }
                }

                // ================== Avatar (Web এর মতো) ==================
                String? avatarUrl;
                if (!isGroup) {
                  avatarUrl = conv.otherUserAvatar; // Web এ এটাই ব্যবহার করা হয়েছে
                }

                return GestureDetector(
                  onTap: () {
                    if (isGroup) {
                      Navigator.pushNamed(context, RouteNames.groupChatScreen, arguments: conv.id);
                    } else {
                      Navigator.pushNamed(context, RouteNames.oneTwoOneChatScreen, arguments: conv.id);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              height: 48.h,
                              width: 48.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff1F283D),
                              ),
                              child: avatarUrl != null && avatarUrl.isNotEmpty
                                  ? ClipOval(
                                child: Image.network(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white),
                                ),
                              )
                                  : const Icon(Icons.person, color: Colors.white),
                            ),

                            SizedBox(width: 12.w),

                            // Name + Last Message
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    lastMsg,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xff8C9196),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Time
                            Text(
                              time,
                              style: const TextStyle(
                                color: Color(0xff8C9196),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        const Divider(color: Color(0xff121D2D), thickness: 1),
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