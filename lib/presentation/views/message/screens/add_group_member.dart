import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/services/token_storage.dart';
import '../../../../cors/services/user_id_storage.dart';
import '../provider/create_group_provider.dart';
import '../model/suggest_model.dart';

class AddGroupMember extends StatefulWidget {
  const AddGroupMember({super.key});

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _groupTitleController = TextEditingController();
  final Set<String> _selectedUserIds = {};
  String? _token;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _groupTitleController.text = 'New Group';
    _loadCredentials();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateGroupProvider>().loadSuggestedUsers();
    });
  }

  Future<void> _loadCredentials() async {
    _token = await TokenStorage().getToken();
    _currentUserId = await UserIdStorage().getUserId();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupTitleController.dispose();
    super.dispose();
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateGroupProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      appBar: AppBar(
        backgroundColor: const Color(0xff030D15),
        title: const Text("New group", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: false,
        actions: [
          if (_selectedUserIds.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: GestureDetector(
                onTap: () async {
                  final createProvider = context.read<CreateGroupProvider>();
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);

                  await createProvider.createGroup(
                    selectedUserIds: _selectedUserIds,
                    groupTitle: _groupTitleController.text.trim().isEmpty
                        ? 'New Group'
                        : _groupTitleController.text.trim(),
                  );

                  if (!mounted) return;

                  if (createProvider.createGroupModel != null) {
                    final group = createProvider.createGroupModel!;
                    navigator.pushReplacementNamed(
                      RouteNames.chatScreen,
                      arguments: {
                        'conversationId': group.id ?? '',
                        'type': 'GROUP',
                        'title': group.title ?? 'Group Chat',
                        'currentUserId': _currentUserId ?? '',
                      },
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(createProvider.errorMessage ?? "Failed to create group"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffE9201D),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // ==================== Group Title Field ====================
                  Container(
                    height: 54.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff030D15),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xff1F283D)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 8.w),
                          child: Text(
                            "Group Name:",
                            style: TextStyle(
                              color: const Color(0xff3D4566),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _groupTitleController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "1 YP A1-2025",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Search Field
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) => provider.searchUsers(value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: const TextStyle(color: Color(0xff5C6580)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xff5C6580)),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff1F283D), width: 1),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff1F283D), width: 1),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  if (_selectedUserIds.isNotEmpty) ...[
                    SizedBox(
                      height: 80.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedUserIds.length,
                        itemBuilder: (context, index) {
                          final userId = _selectedUserIds.elementAt(index);
                          Items user;
                          try {
                            user = provider.users.firstWhere((u) => u.id == userId);
                          } catch (_) {
                            user = Items(id: userId, name: 'User');
                          }
                          return Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        user?.avatarUrl?.isNotEmpty == true
                                            ? user!.avatarUrl!
                                            : "https://i.pravatar.cc/150?img=68",
                                        height: 50.h,
                                        width: 50.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 50.h,
                                          width: 50.h,
                                          color: Colors.grey[800],
                                          child: const Icon(Icons.person, color: Colors.white, size: 28),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () => _toggleSelection(userId),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xff8D9CDC),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  user?.name.split(' ').first ?? '',
                                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  SizedBox(height: 20.h),

                  const Text(
                    "Suggested",
                    style: TextStyle(color: Color(0xffB2B5B8), fontSize: 16),
                  ),

                  SizedBox(height: 12.h),

                  // Suggested Users List
                  Expanded(
                    child: provider.isLoading && provider.users.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(color: Colors.white))
                        : provider.users.isEmpty
                            ? const Center(
                                child: Text(
                                  'No suggestions found',
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                itemCount: provider.users.length,
                                itemBuilder: (context, index) {
                                  final Items user = provider.users[index];
                        final bool isSelected = _selectedUserIds.contains(user.id);

                        return GestureDetector(
                          onTap: () => _toggleSelection(user.id),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    user.avatarUrl?.isNotEmpty == true
                                        ? user.avatarUrl!
                                        : "https://i.pravatar.cc/150?img=68",
                                    height: 50.h,
                                    width: 50.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 50.h,
                                      width: 50.h,
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (user.username != null && user.username!.isNotEmpty)
                                        Text(
                                          "@${user.username}",
                                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 24.h,
                                  width: 24.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? const Color(0xff8D9CDC) : const Color(0xff1F283D),
                                      width: 2,
                                    ),
                                    color: isSelected ? const Color(0xff8D9CDC) : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}