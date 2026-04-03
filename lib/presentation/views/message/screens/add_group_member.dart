import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _groupTitleController.text = "New Group"; // Default title
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateGroupProvider>().searchUsers("");
    });
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
        title: const Text("Add Member"),
        actions: [
          if (_selectedUserIds.isNotEmpty)
            TextButton(
              onPressed: () async {
                final createProvider = context.read<CreateGroupProvider>();

                await createProvider.createGroup(
                  selectedUserIds: _selectedUserIds,
                  groupTitle: _groupTitleController.text.trim().isEmpty
                      ? "New Group"
                      : _groupTitleController.text.trim(),
                );

                if (createProvider.createGroupModel != null) {
                  Navigator.pop(context, _selectedUserIds.toList());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to create group")),
                  );
                }
              },
              child: Text(
                "Done (${_selectedUserIds.length})",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                  TextFormField(
                    controller: _groupTitleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Group Title",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.group, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Search Field
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) => provider.searchUsers(value),
                    decoration: InputDecoration(
                      hintText: "Search users",
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3D4566), width: 1),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  const Text(
                    "Suggested",
                    style: TextStyle(color: Color(0xffB2B5B8), fontSize: 16),
                  ),

                  SizedBox(height: 12.h),

                  // Suggested Users List
                  Expanded(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : provider.suggestModel == null || provider.suggestModel!.items.isEmpty
                        ? const Center(
                      child: Text(
                        "No suggestions found",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                        : ListView.builder(
                      itemCount: provider.suggestModel!.items.length,
                      itemBuilder: (context, index) {
                        final Items user = provider.suggestModel!.items[index];
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
                                  height: 28.h,
                                  width: 28.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.green : const Color(0xff3D4566),
                                      width: 2,
                                    ),
                                    color: isSelected ? Colors.green : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 18)
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