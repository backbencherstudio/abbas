
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../cors/theme/app_colors.dart';
import '../../viewmodels/parent/parent_screen_provider.dart';
import '../community/presentaion/screen/community_screen.dart';
import '../course_screen/course_screen.dart' show CourseScreen;
import '../home/screen/home_screen.dart';
import '../home/screen/screens/home_for_prospective_students/pros_home.dart';
import '../message/screen/message_screens.dart';
import '../profile/profile_screen.dart';

class ParentScreenTwo extends StatelessWidget {
  const ParentScreenTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ParentViewModel>(
        builder: (_, vm, __) {
          return IndexedStack(
            index: vm.index,
            children: [
              ProsHome(), // tab 0
               CommunityScreen(), // tab 1
              const CourseScreen(), // tab 2
              const MessageScreens(), // tab 3
              const ProfileScreen(), // tab 4
            ],
          );
        },
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();
  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF131C24);
    const active = Color(0xFFE33632);
    const inactive = Color(0xFF8A96A3);

    final vm = context.watch<ParentViewModel>();

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 2,
                color: active.withOpacity(0.4),
              ), // top red line
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Item(
                      label: 'Home',
                      activeIcon: 'assets/icons/home_red.svg',
                      inactiveIcon: 'assets/icons/home.svg',
                      isActive: vm.index == 0,
                      onTap: () => vm.setIndex(0),
                    ),
                    _Item(
                      label: 'Community',
                      activeIcon: 'assets/icons/user_group_red.svg',
                      inactiveIcon: 'assets/icons/user_group.svg',
                      isActive: vm.index == 1,
                      onTap: () => vm.setIndex(1),
                    ),
                    _Item(
                      label: 'Course',
                      activeIcon: 'assets/icons/course_red.svg',
                      inactiveIcon: 'assets/icons/course.svg',
                      isActive: vm.index == 2,
                      onTap: () => vm.setIndex(2),
                    ),
                    _Item(
                      label: 'Message',
                      activeIcon: 'assets/icons/message_red.svg',
                      inactiveIcon: 'assets/icons/message.svg',
                      isActive: vm.index == 3,
                      onTap: () => vm.setIndex(3),
                    ),
                    _Item(
                      label: 'Profile',
                      activeIcon: 'assets/icons/user_red.svg',
                      inactiveIcon: 'assets/icons/user1.svg',
                      isActive: vm.index == 4,
                      onTap: () => vm.setIndex(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String activeIcon;
  final String inactiveIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _Item({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const active = Color(0xFFE33632);
    const inactive = Color(0xFF8A96A3);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(isActive ? activeIcon : inactiveIcon, height: 22.h, width: 22.w),
            const SizedBox(height: 6),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? active : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

