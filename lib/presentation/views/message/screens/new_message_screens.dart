import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_appber.dart';

class NewMessageScreens extends StatefulWidget {
  const NewMessageScreens({super.key});

  @override
  State<NewMessageScreens> createState() => _NewMessageScreensState();
}

class _NewMessageScreensState extends State<NewMessageScreens> {
  String _selectedCategory = 'Students';

  final Map<String, List<Map<String, String>>> _categorizedUsers = {
    'Students': [
      {
        'name': 'Cameron Williamson',
        'avatar': 'https://i.pravatar.cc/150?img=1',
      },
      {'name': 'Albert Flores', 'avatar': 'https://i.pravatar.cc/150?img=2'},
      {'name': 'Courtney Henry', 'avatar': 'https://i.pravatar.cc/150?img=3'},
      {'name': 'Cody Fisher', 'avatar': 'https://i.pravatar.cc/150?img=4'},
      {'name': 'Savannah Nguyen', 'avatar': 'https://i.pravatar.cc/150?img=5'},
    ],
    'Teachers': [
      {'name': 'Emily Davis', 'avatar': 'https://i.pravatar.cc/150?img=10'},
      {'name': 'John Doe', 'avatar': 'https://i.pravatar.cc/150?img=11'},
      {'name': 'Jane Smith', 'avatar': 'https://i.pravatar.cc/150?img=12'},
    ],
    'Admin': [
      {'name': 'Alex Johnson', 'avatar': 'https://i.pravatar.cc/150?img=13'},
      {'name': 'Taylor Green', 'avatar': 'https://i.pravatar.cc/150?img=14'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff060C11),
      body: Column(
        children: [
          const SecondaryAppBar(title: "New Message"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff030D15),
                      hintText: " To : Type a user name",
                      hintStyle: const TextStyle(color: Color(0xff3D4566)),
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
                  SizedBox(height: 18.h),
                  PrimaryButton(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.createGroupScreen);
                    },
                    color: const Color(0xffE9201D),
                    textColor: Colors.white,
                    child: Text("Create Group Chat"),
                  ),
                  SizedBox(height: 10.h),
                  const Text(
                    "Suggested",
                    style: TextStyle(color: Color(0xffB2B5B8)),
                  ),
                  SizedBox(height: 10.h),
                  // Category buttons for Students, Teachers, Admin
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryButton("Students"),
                        _buildCategoryButton("Teachers"),
                        _buildCategoryButton("Admin"),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  // User list
                  Expanded(
                    child: ListView.builder(
                      itemCount: _categorizedUsers[_selectedCategory]!.length,
                      itemBuilder: (context, index) {
                        final user =
                            _categorizedUsers[_selectedCategory]![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildUserItem(user['name']!, user['avatar']!),
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

  Widget _buildCategoryButton(String title) {
    bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff363E51) : const Color(0xff030D15),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: const Color(0xff3D4566), width: 1),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xffB2B5B8),
          ),
        ),
      ),
    );
  }

  Widget _buildUserItem(String name, String avatarUrl) {
    return Row(
      children: [
        CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
        SizedBox(width: 10.w),
        Text(name, style: const TextStyle(color: Color(0xffB2B5B8))),
      ],
    );
  }
}
