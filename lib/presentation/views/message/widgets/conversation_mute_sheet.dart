import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/conversation_detail_model.dart';
import '../provider/conversation_detail_provider.dart';

Future<void> showConversationMuteSheet({
  required BuildContext context,
  required ConversationDetailProvider provider,
  required String conversationId,
  required String contactName,
  required bool isSilenced,
  String? mutedUntil,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xff152033),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff3D4466),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                isSilenced ? 'Muted notifications' : 'Mute notifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                isSilenced
                    ? _mutedSubtitle(contactName, mutedUntil)
                    : 'Other members will not see that you muted this chat. You will not receive notifications.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff8C9196),
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              if (isSilenced) ...[
                _MuteOption(
                  label: 'Unmute notifications',
                  onTap: () => _apply(
                    sheetContext: sheetContext,
                    rootContext: context,
                    provider: provider,
                    conversationId: conversationId,
                    mode: 'off',
                    successMessage: 'Notifications unmuted',
                  ),
                ),
                SizedBox(height: 8.h),
                Divider(color: const Color(0xff1F283D), height: 1.h),
                SizedBox(height: 8.h),
              ],
              _MuteOption(
                label: '8 hours',
                onTap: () => _apply(
                  sheetContext: sheetContext,
                  rootContext: context,
                  provider: provider,
                  conversationId: conversationId,
                  mode: 'until',
                  untilAt: DateTime.now().add(const Duration(hours: 8)),
                  successMessage: 'Muted for 8 hours',
                ),
              ),
              _MuteOption(
                label: '1 week',
                onTap: () => _apply(
                  sheetContext: sheetContext,
                  rootContext: context,
                  provider: provider,
                  conversationId: conversationId,
                  mode: 'until',
                  untilAt: DateTime.now().add(const Duration(days: 7)),
                  successMessage: 'Muted for 1 week',
                ),
              ),
              _MuteOption(
                label: 'Always',
                onTap: () => _apply(
                  sheetContext: sheetContext,
                  rootContext: context,
                  provider: provider,
                  conversationId: conversationId,
                  mode: 'forever',
                  successMessage: 'Muted always',
                ),
              ),
              SizedBox(height: 8.h),
              _MuteOption(
                label: 'Cancel',
                isCancel: true,
                onTap: () => Navigator.pop(sheetContext),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String _mutedSubtitle(String contactName, String? mutedUntil) {
  if (mutedUntil != null && mutedUntil.isNotEmpty) {
    return 'Notifications for $contactName are muted until ${formatMutedUntil(mutedUntil)}.';
  }
  return 'Notifications for $contactName are muted.';
}

Future<void> _apply({
  required BuildContext sheetContext,
  required BuildContext rootContext,
  required ConversationDetailProvider provider,
  required String conversationId,
  required String mode,
  DateTime? untilAt,
  required String successMessage,
}) async {
  Navigator.pop(sheetContext);

  final success = await provider.updateSilent(
    conversationId: conversationId,
    mode: mode,
    untilAt: untilAt,
  );

  if (!rootContext.mounted) return;

  ScaffoldMessenger.of(rootContext).showSnackBar(
    SnackBar(
      content: Text(
        success ? successMessage : (provider.error ?? 'Failed to update mute'),
      ),
      backgroundColor: success ? null : Colors.red,
    ),
  );
}

class _MuteOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isCancel;

  const _MuteOption({
    required this.label,
    required this.onTap,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isCancel ? const Color(0xff8C9196) : Colors.white,
              fontSize: 16.sp,
              fontWeight: isCancel ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
