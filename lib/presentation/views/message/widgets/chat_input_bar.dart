import 'dart:async';
import 'dart:io';

import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/message/model/chat_send_payload.dart';
import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:abbas/presentation/views/message/model/pending_attachment.dart';
import 'package:abbas/presentation/views/message/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:characters/characters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

typedef ChatSendCallback = Future<void> Function(ChatSendPayload payload);
typedef TypingCallback = void Function(bool isTyping);

class ChatInputBar extends StatefulWidget {
  final bool isSending;
  final MessageReply? replyTo;
  final ChatSendCallback onSend;
  final TypingCallback onTypingChanged;
  final VoidCallback? onCancelReply;

  const ChatInputBar({
    super.key,
    required this.isSending,
    required this.onSend,
    required this.onTypingChanged,
    this.replyTo,
    this.onCancelReply,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AudioRecorder _recorder = AudioRecorder();
  final ImagePicker _imagePicker = ImagePicker();

  final List<PendingAttachment> _pending = [];
  bool _showEmojiPicker = false;
  bool _hasText = false;
  bool _isRecording = false;
  String? _recordingPath;
  Timer? _recordTimer;
  Duration _recordDuration = Duration.zero;

  bool get _canSend =>
      !_isRecording &&
      !widget.isSending &&
      (_hasText || _pending.isNotEmpty);

  bool get _showSendButton => _hasText || _pending.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _recorder.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final sanitized = _sanitizeText(_controller.text);
    if (sanitized != _controller.text) {
      _controller.value = TextEditingValue(
        text: sanitized,
        selection: TextSelection.collapsed(offset: sanitized.length),
      );
      return;
    }

    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onTypingChanged(hasText);
  }

  TextSelection _effectiveSelection() {
    final text = _controller.text;
    final selection = _controller.selection;
    if (!selection.isValid || selection.start < 0) {
      return TextSelection.collapsed(offset: text.length);
    }
    return selection;
  }

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _effectiveSelection();
    final start = selection.start;
    final end = selection.end;
    final updated = text.replaceRange(start, end, emoji);
    _controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  void _deleteBeforeCursor() {
    final text = _controller.text;
    final selection = _effectiveSelection();

    if (!selection.isCollapsed) {
      final updated = text.replaceRange(selection.start, selection.end, '');
      _controller.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: selection.start),
      );
      return;
    }

    final cursor = selection.start;
    if (cursor <= 0) return;

    final before = text.substring(0, cursor);
    final after = text.substring(cursor);
    final beforeChars = before.characters;
    if (beforeChars.isEmpty) return;

    final newBefore = beforeChars.skipLast(1).toString();
    final updated = newBefore + after;

    _controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: newBefore.length),
    );
  }

  /// Strips lone UTF-16 surrogates left by incorrect backspace handling.
  String _sanitizeText(String value) {
    if (value.isEmpty) return value;
    final buffer = StringBuffer();
    for (final rune in value.runes) {
      buffer.writeCharCode(rune);
    }
    return buffer.toString();
  }

  void _addPending(PendingAttachment attachment) {
    setState(() => _pending.add(attachment));
  }

  void _removePending(int index) {
    setState(() => _pending.removeAt(index));
  }

  MessageKind _kindFromExtension(String path) {
    final ext = p.extension(path).toLowerCase();
    if (['.jpg', '.jpeg', '.png', '.gif', '.webp', '.heic'].contains(ext)) {
      return MessageKind.image;
    }
    if (['.mp4', '.mov', '.avi', '.mkv', '.webm'].contains(ext)) {
      return MessageKind.video;
    }
    if (['.mp3', '.m4a', '.aac', '.wav', '.ogg', '.caf'].contains(ext)) {
      return MessageKind.audio;
    }
    return MessageKind.file;
  }

  Future<void> _pickImages({required ImageSource source}) async {
    try {
      if (source == ImageSource.gallery) {
        final files = await _imagePicker.pickMultiImage();
        for (final x in files) {
          _addPending(PendingAttachment(
            path: x.path,
            fileName: p.basename(x.path),
            kind: MessageKind.image,
          ));
        }
      } else {
        final file = await _imagePicker.pickImage(source: source);
        if (file == null) return;
        _addPending(PendingAttachment(
          path: file.path,
          fileName: p.basename(file.path),
          kind: MessageKind.image,
        ));
      }
    } catch (e) {
      _showSnack('Could not pick image');
    }
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
    if (result == null) return;
    for (final f in result.files) {
      if (f.path == null) continue;
      _addPending(PendingAttachment(
        path: f.path!,
        fileName: f.name,
        kind: MessageKind.video,
      ));
    }
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result == null) return;
    for (final f in result.files) {
      if (f.path == null) continue;
      _addPending(PendingAttachment(
        path: f.path!,
        fileName: f.name,
        kind: MessageKind.audio,
      ));
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    if (result == null) return;
    for (final f in result.files) {
      if (f.path == null) continue;
      _addPending(PendingAttachment(
        path: f.path!,
        fileName: f.name,
        kind: _kindFromExtension(f.path!),
      ));
    }
  }

  void _showAttachmentSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xff152033),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              _SheetOption(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                color: const Color(0xffE9201D),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImages(source: ImageSource.gallery);
                },
              ),
              _SheetOption(
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                color: const Color(0xff8D9CDC),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImages(source: ImageSource.camera);
                },
              ),
              _SheetOption(
                icon: Icons.videocam_outlined,
                label: 'Video',
                color: const Color(0xff4CAF50),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickVideo();
                },
              ),
              _SheetOption(
                icon: Icons.audiotrack_outlined,
                label: 'Audio',
                color: const Color(0xffFF9800),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAudioFile();
                },
              ),
              _SheetOption(
                icon: Icons.insert_drive_file_outlined,
                label: 'Document',
                color: const Color(0xff5C6580),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickDocument();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _ensureMicPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    if (_isRecording || widget.isSending) return;
    if (!await _ensureMicPermission()) {
      _showSnack('Microphone permission is required');
      return;
    }
    if (!await _recorder.hasPermission()) {
      _showSnack('Microphone permission is required');
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = p.join(
      dir.path,
      'voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _recordingPath = path;
      _recordDuration = Duration.zero;
    });

    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _recordDuration += const Duration(seconds: 1));
      }
    });
  }

  Future<void> _stopRecording({required bool send}) async {
    if (!_isRecording) return;
    _recordTimer?.cancel();
    final recordedDuration = _recordDuration;
    final path = await _recorder.stop();
    final filePath = path ?? _recordingPath;

    setState(() {
      _isRecording = false;
      _recordingPath = null;
      _recordDuration = Duration.zero;
    });

    if (!send || filePath == null) {
      if (filePath != null) {
        try {
          await File(filePath).delete();
        } catch (_) {}
      }
      return;
    }

    final file = File(filePath);
    if (!await file.exists()) return;
    final bytes = await file.length();
    if (recordedDuration.inSeconds < 1 && bytes < 1000) {
      try {
        await file.delete();
      } catch (_) {}
      return;
    }

    await widget.onSend(ChatSendPayload(
      kind: MessageKind.audio,
      filePaths: [filePath],
      replyToId: widget.replyTo?.id,
    ));
  }

  Future<void> _handleSend() async {
    if (!_canSend) return;

    final text = _controller.text.trim();
    final paths = _pending.map((e) => e.path).toList();
    final kind = _pending.isNotEmpty
        ? _pending.first.kind
        : MessageKind.text;

    await widget.onSend(ChatSendPayload(
      text: text.isNotEmpty ? text : null,
      kind: kind,
      filePaths: paths,
      replyToId: widget.replyTo?.id,
    ));

    _controller.clear();
    setState(() => _pending.clear());
    widget.onTypingChanged(false);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyTo != null && widget.onCancelReply != null)
          ReplyInputBanner(
            reply: widget.replyTo!,
            onCancel: widget.onCancelReply!,
          ),
        if (_isRecording) _RecordingBanner(duration: _recordDuration),
        if (_pending.isNotEmpty) _AttachmentPreviewStrip(
          attachments: _pending,
          onRemove: _removePending,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
          decoration: BoxDecoration(
            color: const Color(0xff030D15),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: widget.isSending ? null : _showAttachmentSheet,
                  icon: Icon(Icons.add, color: Colors.white70, size: 28.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  onPressed: widget.isSending
                      ? null
                      : () => _pickImages(source: ImageSource.gallery),
                  icon: Icon(Icons.image_outlined,
                      color: Colors.white70, size: 26.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 44.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff152033),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            enabled: !_isRecording && !widget.isSending,
                            maxLines: 5,
                            minLines: 1,
                            style: const TextStyle(color: Colors.white),
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                                  final sanitized =
                                      _sanitizeText(newValue.text);
                                  if (sanitized == newValue.text) {
                                    return newValue;
                                  }
                                  return TextEditingValue(
                                    text: sanitized,
                                    selection: TextSelection.collapsed(
                                      offset: sanitized.length,
                                    ),
                                  );
                                },
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Type message...',
                              hintStyle: TextStyle(
                                color: const Color(0xff5C6580),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                            ),
                            onTap: () {
                              if (_showEmojiPicker) {
                                setState(() => _showEmojiPicker = false);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showEmojiPicker = !_showEmojiPicker;
                              if (_showEmojiPicker) {
                                _focusNode.unfocus();
                              } else {
                                _focusNode.requestFocus();
                              }
                            });
                          },
                          icon: Icon(
                            _showEmojiPicker
                                ? Icons.keyboard_outlined
                                : Icons.emoji_emotions_outlined,
                            color: const Color(0xff5C6580),
                            size: 22.sp,
                          ),
                          padding: EdgeInsets.only(right: 4.w),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                if (widget.isSending)
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.activeButtonColor,
                      ),
                    ),
                  )
                else if (_showSendButton)
                  IconButton(
                    onPressed: _canSend ? _handleSend : null,
                    icon: Icon(Icons.send_rounded,
                        color: const Color(0xffE9201D), size: 26.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  GestureDetector(
                    onLongPressStart: (_) => _startRecording(),
                    onLongPressEnd: (_) => _stopRecording(send: true),
                    onLongPressCancel: () => _stopRecording(send: false),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        _isRecording ? Icons.mic : Icons.mic_none,
                        color: _isRecording
                            ? const Color(0xffE9201D)
                            : const Color(0xff5C6580),
                        size: 28.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 250.h,
            child: EmojiPicker(
              onEmojiSelected: (_, emoji) => _insertEmoji(emoji.emoji),
              onBackspacePressed: _deleteBeforeCursor,
              config: Config(
                height: 250.h,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: const Color(0xff152033),
                  columns: 8,
                ),
                categoryViewConfig: const CategoryViewConfig(
                  backgroundColor: Color(0xff152033),
                  indicatorColor: Color(0xffE9201D),
                  iconColorSelected: Color(0xffE9201D),
                ),
                bottomActionBarConfig: const BottomActionBarConfig(
                  backgroundColor: Color(0xff152033),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RecordingBanner extends StatelessWidget {
  final Duration duration;

  const _RecordingBanner({required this.duration});

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: const Color(0xffE9201D).withValues(alpha: 0.15),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record,
              color: const Color(0xffE9201D), size: 14.sp),
          SizedBox(width: 8.w),
          Text(
            'Recording ${_format(duration)}',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          const Spacer(),
          Text(
            'Release to send',
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class _AttachmentPreviewStrip extends StatelessWidget {
  final List<PendingAttachment> attachments;
  final ValueChanged<int> onRemove;

  const _AttachmentPreviewStrip({
    required this.attachments,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 4.h),
      color: const Color(0xff0A1520),
      child: SizedBox(
        height: 72.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: attachments.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final item = attachments[index];
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 72.w,
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff152033),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xff1F283D)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: item.isImage
                        ? Image.file(item.file, fit: BoxFit.cover)
                        : Center(
                            child: Icon(
                              item.isVideo
                                  ? Icons.videocam_outlined
                                  : item.isAudio
                                      ? Icons.mic_outlined
                                      : Icons.insert_drive_file_outlined,
                              color: Colors.white70,
                              size: 28.sp,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: GestureDetector(
                    onTap: () => onRemove(index),
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(
                        color: Color(0xffE9201D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 14.sp),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22.sp),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
