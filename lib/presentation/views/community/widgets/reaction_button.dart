import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../presentaion/provider/community/community_screen_provider.dart';

class ReactionType {
  final String emoji;
  final String label;
  final Color color;

  const ReactionType({
    required this.emoji,
    required this.label, 
    required this.color,
  });
}

const kReactions = [
  ReactionType(emoji: '👍', label: 'Like', color: Color(0xFF2078F4)),
  ReactionType(emoji: '❤️', label: 'Love', color: Color(0xFFF33E58)),
  ReactionType(emoji: '😂', label: 'Haha', color: Color(0xFFF7B125)),
  ReactionType(emoji: '😮', label: 'Wow', color: Color(0xFFF7B125)),
  ReactionType(emoji: '😡', label: 'Angry', color: Color(0xFFE9710F)),
];

class ReactionButton extends StatefulWidget {
  final String postId;

  const ReactionButton({super.key, required this.postId});

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  OverlayEntry? _overlayEntry;

  void _showReactionBar(CommunityScreenProvider provider) {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (ctx) => _ReactionOverlay(
        anchorOffset: offset,
        anchorSize: size,
        reactions: kReactions,
        onReactionSelected: (reaction) {
          // Store in provider — triggers notifyListeners, no setState needed
          provider.setReaction(widget.postId, reaction.label);
          provider.createPostLike(widget.postId);
          _removeOverlay();
        },
        onDismiss: _removeOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Consumer listens to CommunityScreenProvider for this post's reaction
    return Consumer<CommunityScreenProvider>(
      builder: (context, provider, _) {
        final reactionLabel = provider.getReaction(widget.postId);
        final reaction = reactionLabel != null
            ? kReactions.firstWhere(
                (r) => r.label == reactionLabel,
                orElse: () => kReactions.first,
              )
            : null;

        return GestureDetector(
          onTap: () => _showReactionBar(provider),
          onLongPress: () => _showReactionBar(provider),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              reaction != null
                  ? Text(reaction.emoji, style: TextStyle(fontSize: 20.sp))
                  : Image.asset(
                      'assets/icons/like_icon.png',
                      width: 24.w,
                      height: 24.h,
                    ),
              SizedBox(width: 4.w),
              Text(
                reaction?.label ?? 'Like',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: reaction?.color ?? Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Overlay widget — only hover animation uses local setState (pure UI state)
// ---------------------------------------------------------------------------
class _ReactionOverlay extends StatefulWidget {
  final Offset anchorOffset;
  final Size anchorSize;
  final List<ReactionType> reactions;
  final ValueChanged<ReactionType> onReactionSelected;
  final VoidCallback onDismiss;

  const _ReactionOverlay({
    required this.anchorOffset,
    required this.anchorSize,
    required this.reactions,
    required this.onReactionSelected,
    required this.onDismiss,
  });

  @override
  State<_ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<_ReactionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // Hover is pure local UI — intentionally local state, not provider
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnim = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bubbleHeight = 60.0;
    const bubbleWidth = 290.0;

    double left = widget.anchorOffset.dx - 8;
    double top = widget.anchorOffset.dy - bubbleHeight - 12;

    final screenWidth = MediaQuery.of(context).size.width;
    if (left + bubbleWidth > screenWidth) left = screenWidth - bubbleWidth - 8;
    if (left < 8) left = 8;

    return Stack(
      children: [
        // Dismiss layer
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) => Opacity(
              opacity: _fadeAnim.value,
              child: Transform.scale(
                scale: _scaleAnim.value,
                alignment: Alignment.bottomLeft,
                child: child,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2D3D),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.reactions.length, (i) {
                    final r = widget.reactions[i];
                    final isHovered = _hoveredIndex == i;
                    return GestureDetector(
                      onTapDown: (_) =>
                          setState(() => _hoveredIndex = i),
                      onTapUp: (_) {
                        setState(() => _hoveredIndex = null);
                        widget.onReactionSelected(r);
                      },
                      onTapCancel: () =>
                          setState(() => _hoveredIndex = null),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        transform: Matrix4.translationValues(
                            0, isHovered ? -12 : 0, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 150),
                              style: TextStyle(
                                fontSize: isHovered ? 34 : 26,
                              ),
                              child: Text(r.emoji),
                            ),
                            if (isHovered)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  r.label,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: r.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
