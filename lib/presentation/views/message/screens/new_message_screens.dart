import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/services/token_storage.dart';
import '../../../../cors/services/user_id_storage.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_appber.dart';
import '../model/suggest_model.dart';
import '../provider/create_chat_provider.dart';
import '../provider/create_group_provider.dart';

class NewMessageScreens extends StatefulWidget {
  const NewMessageScreens({super.key});

  @override
  State<NewMessageScreens> createState() => _NewMessageScreensState();
}

class _NewMessageScreensState extends State<NewMessageScreens> {
  final TextEditingController _searchController = TextEditingController();
  String? _token;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    _token = await TokenStorage().getToken();
    _currentUserId = await UserIdStorage().getUserId();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Start a DM with the selected user.
  Future<void> _startDm(BuildContext context, Items user) async {
    final provider = context.read<CreateChatProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final conv = await provider.createConversation(user.id);

    if (!mounted) return;

    if (conv != null) {
      navigator.pushNamed(
        RouteNames.oneTwoOneChatScreen,
        arguments: {
          "conversationId": conv.id,
          "token": _token ?? '',
          "currentUserId": _currentUserId ?? '',
          "receiverName": user.name,
        },
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to start chat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff060C11),
      body: Column(
        children: [
          const SecondaryAppBar(title: "New Message"),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h),
                  // Search field
                  Consumer<CreateGroupProvider>(
                    builder: (context, searchProvider, _) {
                      return TextFormField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          searchProvider.searchUsers(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                          hintText: "To: Type a user name",
                          hintStyle: const TextStyle(color: Color(0xff5C6580)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Color(0xff5C6580)),
                                  onPressed: () {
                                    _searchController.clear();
                                    searchProvider.clearSearch();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xff1F283D),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xff1F283D),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xff3D4566),
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Create Group button
                  PrimaryButton(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteNames.addGroupMember);
                    },
                    color: const Color(0xffE9201D),
                    textColor: Colors.white,
                    // borderRadius: BorderRadius.circular(16.r),
                    // height: 54.h,
                    child: const Text("Create Group Chat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 18.h),
                  // Search results / Suggested label
                  Consumer<CreateGroupProvider>(
                    builder: (context, searchProvider, _) {
                      final results =
                          searchProvider.suggestModel?.items ?? [];
                      final isSearching = _searchController.text.isNotEmpty;

                      if (searchProvider.isLoading) {
                        return const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffE9201D),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: 16.h),
                            // Text(
                            //   isSearching ? "Results" : "Suggested",
                            //   style: const TextStyle(
                            //     color: Color(0xffB2B5B8),
                            //     fontSize: 14,
                            //   ),
                            // ),
                            // if (!isSearching) ...[
                            //   SizedBox(height: 16.h),
                            //   SizedBox(
                            //     height: 38.h,
                            //     child: ListView(
                            //       scrollDirection: Axis.horizontal,
                            //       children: ['Students', 'Teachers', 'Admin'].map((filter) {
                            //         final isSelected = filter == 'Students';
                            //         return Padding(
                            //           padding: EdgeInsets.only(right: 12.w),
                            //           child: Container(
                            //             padding: EdgeInsets.symmetric(
                            //               horizontal: 20.w,
                            //               vertical: 8.h,
                            //             ),
                            //             decoration: BoxDecoration(
                            //               border: Border.all(
                            //                 color: const Color(0xff1F283D),
                            //                 width: 1.w,
                            //               ),
                            //               borderRadius: BorderRadius.circular(50.r),
                            //               color: isSelected
                            //                   ? const Color(0xff3D4566)
                            //                   : Colors.transparent,
                            //             ),
                            //             child: Text(
                            //               filter,
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 14.sp,
                            //                 fontWeight: FontWeight.w400,
                            //               ),
                            //             ),
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ],
                            if (isSearching && results.isEmpty)
                              const Center(
                                child: Text(
                                  "No users found",
                                  style: TextStyle(color: Color(0xff8C9196)),
                                ),
                              )
                            else
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: 5),
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    final user = results[index];
                                    return _buildUserItem(context, user);
                                  },
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
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(BuildContext context, Items user) {
    return Consumer<CreateChatProvider>(
      builder: (context, chatProvider, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: chatProvider.isLoading
              ? null
              : () => _startDm(context, user),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1F283D),
                  ),
                  child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.person, color: Colors.white),
                          ),
                        )
                      : const Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (user.username != null && user.username!.isNotEmpty)
                        Text(
                          user.username!,
                          style: const TextStyle(
                            color: Color(0xff8C9196),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                if (chatProvider.isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xffE9201D),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xff8C9196),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
