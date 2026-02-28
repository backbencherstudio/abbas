
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/secondary_appber.dart';

class PushNotifications extends StatelessWidget {
  const PushNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030C15),
      body: Column(
        children: [
          SecondaryAppBar(title: 'Push Notifications'),
          SizedBox(height: 10.h,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children:  [
                SizedBox(height: 20.h),
                _NotificationSettingItem(
                  title: 'New Announcements',
                  initialValue: true,
                ),
                _NotificationSettingItem(
                  title: 'Payment Reminders',
                  initialValue: false,
                ),
                _NotificationSettingItem(
                  title: 'Course Availability',
                  initialValue: false,
                ),
                _NotificationSettingItem(
                  title: 'Community Mentions',
                  initialValue: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingItem extends StatefulWidget {
  final String title;
  final bool initialValue;

  const _NotificationSettingItem({
    required this.title,
    required this.initialValue,
  });

  @override
  State<_NotificationSettingItem> createState() =>
      _NotificationSettingItemState();
}

class _NotificationSettingItemState extends State<_NotificationSettingItem> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8.0.h),
      padding:  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: _isToggled,
            onChanged: (value) {
              setState(() {
                _isToggled = value;
              });
              // Handle the toggle change, e.g., save to a database or preferences
            },
            activeColor: Colors.white,
            activeTrackColor: Color(0xFFE9201D),
            inactiveTrackColor: Color(0xFF3D4566),
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
