import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:abbas/presentation/views/message/model/conversation_model.dart';
import 'package:abbas/presentation/views/message/model/call_model.dart';
import 'package:abbas/presentation/views/message/provider/call_provider.dart';
import 'package:abbas/presentation/views/message/provider/chat_provider.dart';
import 'package:abbas/presentation/views/message/widgets/chat_input_bar.dart';
import 'package:abbas/presentation/views/message/widgets/chat_message_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final ConversationType type;
  final String title;
  final String? avatarUrl;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.type,
    required this.title,
    required this.currentUserId,
    this.avatarUrl,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ChatArgs _args;
  bool _didInit = false;
  MessageReply? _replyingTo;

  @override
  void initState() {
    super.initState();
    _args = ChatArgs(
      conversationId: widget.conversationId,
      type: widget.type,
      title: widget.title,
      avatarUrl: widget.avatarUrl,
    );
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callProvider.notifier).trackConversation(
            widget.conversationId,
            title: widget.title,
            showIncomingIfNeeded: true,
          );
    });
  }

  @override
  void dispose() {
    ref.read(callProvider.notifier).untrackConversation(widget.conversationId);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80) {
      ref.read(chatProvider(_args).notifier).loadMore();
    }
  }

  MessageReply _replyFromMessage(ChatMessage message) {
    return MessageReply(
      id: message.id,
      kind: message.kind,
      content: message.content,
      senderId: message.senderId,
      sender: message.sender,
      attachments: message.attachments,
    );
  }

  void _startReply(ChatMessage message) {
    setState(() => _replyingTo = _replyFromMessage(message));
  }

  void _cancelReply() => setState(() => _replyingTo = null);

  void _showMessageActions(ChatMessage message, {required bool isMe}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xff152033),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff3D4466),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.reply,
                    color: const Color(0xff8D9CDC),
                    size: 22.sp,
                  ),
                  title: const Text(
                    'Reply',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _startReply(message);
                  },
                ),
                if (isMe)
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: const Color(0xffE9201D),
                      size: 22.sp,
                    ),
                    title: const Text(
                      'Delete',
                      style: TextStyle(color: Color(0xffE9201D)),
                    ),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      final success = await ref
                          .read(chatProvider(_args).notifier)
                          .deleteMessage(message.id);
                      if (!mounted) return;
                      if (!success) {
                        final error =
                            ref.read(chatProvider(_args)).error ??
                                'Failed to delete message';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      } else if (_replyingTo?.id == message.id) {
                        _cancelReply();
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startCall(CallKind kind) {
    ref.read(callProvider.notifier).startCall(
          conversationId: widget.conversationId,
          kind: kind,
          title: widget.title,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider(_args));
    final callState = ref.watch(callProvider);

    if (!_didInit) {
      _didInit = true;
      Future.microtask(
        () => ref.read(chatProvider(_args).notifier).init(widget.currentUserId),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      appBar: AppBar(
        backgroundColor: const Color(0xff030D15),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            _UserAvatar(
              url: widget.avatarUrl,
              radius: 18.r,
              isGroup: widget.type.isGroup,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state.isOtherUserTyping)
                    Text(
                      state.typingUserName != null
                          ? '${state.typingUserName} is typing...'
                          : 'typing...',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.greenAccent,
                      ),
                    )
                  else if (widget.type.isGroup)
                    Text(
                      'Group',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => _startCall(CallKind.audio),
            child: Icon(Icons.call, size: 20.sp, color: const Color(0xffE9201D)),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () => _startCall(CallKind.video),
            child: Icon(Icons.videocam_rounded,
                size: 20.sp, color: const Color(0xffE9201D)),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () {
              if (widget.type.isGroup) {
                Navigator.pushNamed(
                  context,
                  RouteNames.groupProfileScreen,
                  arguments: {
                    'conversationId': widget.conversationId,
                    'groupName': widget.title,
                    'avatarUrl': widget.avatarUrl ?? '',
                    'currentUserId': widget.currentUserId,
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  RouteNames.userProfileScreen,
                  arguments: {
                    'conversationId': widget.conversationId,
                    'receiverName': widget.title,
                    'avatarUrl': widget.avatarUrl ?? '',
                  },
                );
              }
            },
            child: Icon(Icons.info, size: 20.sp, color: const Color(0xff8D9CDC)),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          if (_shouldShowJoinChip(callState))
            _ActiveCallChip(
              kind: callState.activeSession!.kind,
              onJoin: () => ref.read(callProvider.notifier).joinOngoingCall(
                    conversationId: widget.conversationId,
                    title: widget.title,
                  ),
            ),
          Expanded(child: _buildMessages(state)),
          ChatInputBar(
            isSending: state.isSending,
            replyTo: _replyingTo,
            onCancelReply: _cancelReply,
            onTypingChanged: (typing) =>
                ref.read(chatProvider(_args).notifier).updateTyping(typing),
            onSend: (payload) async {
              await ref.read(chatProvider(_args).notifier).sendMessage(payload);
              if (mounted) _cancelReply();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(ChatState state) {
    if (state.isInitialLoading && state.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.activeButtonColor),
      );
    }

    if (state.messages.isEmpty) {
      if (state.error != null) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () =>
                      ref.read(chatProvider(_args).notifier).reload(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }
      return const Center(
        child: Text(
          'No messages yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      itemCount: state.messages.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.activeButtonColor,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final msg = state.messages[index];
        final isMe = msg.isMine(widget.currentUserId);
        final showSenderName = widget.type.isGroup &&
            !isMe &&
            msg.sender?.name != null &&
            (index == state.messages.length - 1 ||
                state.messages[index + 1].senderId != msg.senderId);
        final showAvatar = widget.type.isGroup &&
            !isMe &&
            (index == 0 ||
                state.messages[index - 1].senderId != msg.senderId);

        return _MessageBubble(
          message: msg,
          isMe: isMe,
          isGroup: widget.type.isGroup,
          showSenderName: showSenderName,
          showAvatar: showAvatar,
          onLongPress: () => _showMessageActions(msg, isMe: isMe),
        );
      },
    );
  }

  bool _shouldShowJoinChip(CallState callState) {
    final session = callState.activeSession;
    if (session == null || !session.isOngoing) return false;
    if (session.conversationId != widget.conversationId) return false;
    return !callState.isLiveKitConnected && !callState.isConnecting;
  }
}

class _UserAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  final bool isGroup;

  const _UserAvatar({
    this.url,
    required this.radius,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.trim().isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xff1F283D),
      backgroundImage: hasUrl ? NetworkImage(url!) : null,
      child: hasUrl
          ? null
          : Icon(
              isGroup ? Icons.groups : Icons.person,
              color: Colors.white,
              size: radius,
            ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isGroup;
  final bool showSenderName;
  final bool showAvatar;
  final VoidCallback onLongPress;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.isGroup,
    required this.showSenderName,
    required this.showAvatar,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final time = _formatTime(message.createdAt);
    final text = message.bodyText();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showAvatar) ...[
              _UserAvatar(
                url: message.sender?.avatar,
                radius: 16.r,
              ),
              SizedBox(width: 8.w),
            ] else if (!isMe && isGroup) ...[
              SizedBox(width: 40.w),
            ],
            GestureDetector(
              onLongPress: onLongPress,
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (time.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        time,
                        style:
                            TextStyle(color: Colors.white38, fontSize: 11.sp),
                      ),
                    ),
                  if (showSenderName)
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                      child: Text(
                        message.sender!.name!,
                        style: TextStyle(
                          color: const Color(0xff8D9CDC),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 0.72.sw),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xff4A5D83)
                              : const Color(0xff0A1A2A),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.r),
                            topRight: Radius.circular(18.r),
                            bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                            bottomRight: Radius.circular(isMe ? 4.r : 18.r),
                          ),
                        ),
                        child: ChatMessageBody(
                          message: message,
                          text: text,
                          isMe: isMe,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    return DateFormat('hh:mm a').format(dt);
  }
}

class _ActiveCallChip extends StatelessWidget {
  final CallKind kind;
  final VoidCallback onJoin;

  const _ActiveCallChip({required this.kind, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final label = kind.isVideo ? 'Video call in progress' : 'Audio call in progress';
    return Material(
      color: const Color(0xff152033),
      child: InkWell(
        onTap: onJoin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              Icon(
                kind.isVideo ? Icons.videocam : Icons.phone,
                color: const Color(0xffE9201D),
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
              Text(
                'Join',
                style: TextStyle(
                  color: const Color(0xffE9201D),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
