import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreatePool extends ConsumerStatefulWidget {
  const CreatePool({super.key});

  @override
  ConsumerState<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends ConsumerState<CreatePool> {
  final TextEditingController _questionController = TextEditingController();
  final FocusNode _questionFocus = FocusNode();

  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _optionFocusNodes = [FocusNode(), FocusNode()];

  String _visibility = 'PUBLIC';
  bool _isSubmitting = false;
  bool _showEmojiPicker = false;

  static const int _minOptions = 2;
  static const int _maxOptions = 8;

  @override
  void initState() {
    super.initState();
    _questionController.addListener(_onFormChanged);
    for (final c in _optionControllers) {
      c.addListener(_onFormChanged);
    }
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    _questionController.dispose();
    _questionFocus.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    for (final n in _optionFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  bool get _canPost {
    if (_isSubmitting) return false;
    if (_questionController.text.trim().isEmpty) return false;
    final filled =
        _optionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty);
    return filled.length >= _minOptions;
  }

  void _addOption() {
    if (_optionControllers.length >= _maxOptions) {
      Utils.showToast(
        msg: 'You can add up to $_maxOptions options',
        backgroundColor: AppColors.cardBackground,
        textColor: Colors.white,
      );
      return;
    }
    setState(() {
      _optionControllers.add(TextEditingController()..addListener(_onFormChanged));
      _optionFocusNodes.add(FocusNode());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= _minOptions) return;
    setState(() {
      _optionControllers[index].dispose();
      _optionFocusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _optionFocusNodes.removeAt(index);
    });
  }

  void _insertEmoji(String emoji) {
    final text = _questionController.text;
    final selection = _questionController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final updated = text.replaceRange(start, end, emoji);
    _questionController.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  Future<void> _submitPoll() async {
    if (!_canPost || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    final error = await ref.read(communityFeedProvider.notifier).createPoll(
          content: _questionController.text,
          visibility: _visibility,
          pollOptions:
              _optionControllers.map((c) => c.text).toList(growable: false),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      Utils.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Utils.showToast(
      msg: 'Poll created successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    Navigator.pop(context, true);
  }

  Future<bool> _confirmDiscard() async {
    final hasDraft = _questionController.text.trim().isNotEmpty ||
        _optionControllers.any((c) => c.text.trim().isNotEmpty);
    if (!hasDraft) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A1A29),
        title: const Text('Discard poll?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your draft will be lost.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileScreenProvider>();
    final authorImage = profile.profile?.data?.avatar;
    final authorName = profile.profile?.data?.name ?? '';

    return PopScope(
      canPop: !_isSubmitting,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _isSubmitting) return;
        if (await _confirmDiscard() && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            SecondaryAppBar(
              title: 'Create Poll',
              onBack: _isSubmitting
                  ? () {}
                  : () async {
                      if (await _confirmDiscard() && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AuthorRow(
                      authorImage: authorImage,
                      authorName: authorName,
                      visibility: _visibility,
                      enabled: !_isSubmitting,
                      onVisibilityChanged: (v) =>
                          setState(() => _visibility = v),
                    ),
                    SizedBox(height: 20.h),
                    _SectionLabel('Poll Question'),
                    SizedBox(height: 8.h),
                    _QuestionField(
                      controller: _questionController,
                      focusNode: _questionFocus,
                      enabled: !_isSubmitting,
                      onEmojiTap: () =>
                          setState(() => _showEmojiPicker = !_showEmojiPicker),
                    ),
                    if (_showEmojiPicker) ...[
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 250.h,
                        child: EmojiPicker(
                          onEmojiSelected: (_, emoji) => _insertEmoji(emoji.emoji),
                          onBackspacePressed: () {
                            final text = _questionController.text;
                            final selection = _questionController.selection;
                            if (selection.start < 0) return;
                            if (selection.start != selection.end) {
                              final updated = text.replaceRange(
                                selection.start,
                                selection.end,
                                '',
                              );
                              _questionController.value = TextEditingValue(
                                text: updated,
                                selection: TextSelection.collapsed(
                                  offset: selection.start,
                                ),
                              );
                              return;
                            }
                            if (selection.start == 0) return;
                            final updated = text.replaceRange(
                              selection.start - 1,
                              selection.start,
                              '',
                            );
                            _questionController.value = TextEditingValue(
                              text: updated,
                              selection: TextSelection.collapsed(
                                offset: selection.start - 1,
                              ),
                            );
                          },
                          config: Config(
                            height: 250.h,
                            checkPlatformCompatibility: true,
                            emojiViewConfig: EmojiViewConfig(
                              backgroundColor: const Color(0xFF0A1A29),
                              columns: 8,
                            ),
                            skinToneConfig: const SkinToneConfig(),
                            categoryViewConfig: CategoryViewConfig(
                              backgroundColor: const Color(0xFF0A1A29),
                              indicatorColor: AppColors.activeButtonColor,
                              iconColor: Colors.white38,
                              iconColorSelected: Colors.white,
                            ),
                            bottomActionBarConfig: const BottomActionBarConfig(
                              backgroundColor: Color(0xFF0A1A29),
                            ),
                            searchViewConfig: SearchViewConfig(
                              backgroundColor: const Color(0xFF0A1A29),
                              hintText: 'Search emoji',
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    _SectionLabel('Poll Options'),
                    SizedBox(height: 8.h),
                    for (int i = 0; i < _optionControllers.length; i++) ...[
                      _OptionField(
                        controller: _optionControllers[i],
                        focusNode: _optionFocusNodes[i],
                        hintText: 'Option ${i + 1}',
                        enabled: !_isSubmitting,
                        showRemove: _optionControllers.length > _minOptions,
                        onRemove: () => _removeOption(i),
                      ),
                      SizedBox(height: 10.h),
                    ],
                    _AddOptionButton(
                      enabled: !_isSubmitting &&
                          _optionControllers.length < _maxOptions,
                      onTap: _addOption,
                    ),
                    SizedBox(height: 28.h),
                    _PostButton(
                      enabled: _canPost,
                      isSubmitting: _isSubmitting,
                      onPressed: _submitPoll,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final String? authorImage;
  final String authorName;
  final String visibility;
  final bool enabled;
  final ValueChanged<String> onVisibilityChanged;

  const _AuthorRow({
    required this.authorImage,
    required this.authorName,
    required this.visibility,
    required this.enabled,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = authorImage != null && authorImage!.isNotEmpty;
    final label = visibility == 'PUBLIC' ? 'Public' : 'Private';

    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: const Color(0xFF1B2A3A),
          backgroundImage: hasAvatar ? NetworkImage(authorImage!) : null,
          child: hasAvatar
              ? null
              : Icon(Icons.person, size: 20.sp, color: Colors.grey),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            authorName,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<String>(
          enabled: enabled,
          initialValue: visibility,
          color: const Color(0xFF0A1A29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          onSelected: onVisibilityChanged,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'PUBLIC',
              child: Text('Public', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            ),
            PopupMenuItem(
              value: 'PRIVATE',
              child: Text('Private', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A29),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF3D4566)),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onEmojiTap;

  const _QuestionField({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onEmojiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566), width: 1.2),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            maxLines: 4,
            minLines: 3,
            maxLength: 500,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                null,
            style: TextStyle(color: Colors.white, fontSize: 15.sp, height: 1.4),
            decoration: InputDecoration(
              hintText: 'Ask a question...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15.sp),
              contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 48.w, 16.h),
              border: InputBorder.none,
            ),
          ),
          Positioned(
            right: 8.w,
            bottom: 8.h,
            child: IconButton(
              onPressed: enabled ? onEmojiTap : null,
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.white54,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool enabled;
  final bool showRemove;
  final VoidCallback onRemove;

  const _OptionField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.enabled,
    required this.showRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15.sp),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF3D4566), width: 1.2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF3D4566), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF5F6CA0), width: 1.2),
              ),
            ),
          ),
        ),
        if (showRemove) ...[
          SizedBox(width: 8.w),
          IconButton(
            onPressed: enabled ? onRemove : null,
            icon: Icon(Icons.close, color: Colors.white54, size: 20.sp),
          ),
        ],
      ],
    );
  }
}

class _AddOptionButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _AddOptionButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(12.r),
            dashPattern: const [6, 3],
            color: const Color(0xFF3D4566),
            strokeWidth: 1.5,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: const Color(0xFFB2B5B8), size: 20.sp),
                SizedBox(width: 6.w),
                Text(
                  'Add Option',
                  style: TextStyle(
                    color: const Color(0xFFB2B5B8),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  final bool enabled;
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _PostButton({
    required this.enabled,
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && !isSubmitting;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: active ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              active ? const Color(0xFFE9201D) : const Color(0xFF0A1A29),
          disabledBackgroundColor: const Color(0xFF0A1A29),
          foregroundColor: active ? Colors.white : const Color(0xFF3D4566),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: isSubmitting
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                'Post',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
