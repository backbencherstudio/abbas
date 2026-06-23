import 'package:abbas/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Collapses long post text to [maxLines] with a See more / See less toggle.
class ExpandablePostText extends StatefulWidget {
  final String text;
  final int maxLines;
  final bool alwaysExpanded;

  const ExpandablePostText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.alwaysExpanded = false,
  });

  @override
  State<ExpandablePostText> createState() => _ExpandablePostTextState();
}

class _ExpandablePostTextState extends State<ExpandablePostText> {
  bool _expanded = false;

  bool _exceedsMaxLines(String text, TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.white, fontSize: 14.sp);

    if (widget.alwaysExpanded) {
      return Text(widget.text, style: style);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final overflows = _exceedsMaxLines(
          widget.text,
          style,
          constraints.maxWidth,
        );
        final showCollapsed = overflows && !_expanded;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: showCollapsed ? widget.maxLines : null,
              overflow: showCollapsed ? TextOverflow.ellipsis : null,
            ),
            if (overflows) ...[
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  _expanded ? 'See less' : 'See more',
                  style: TextStyle(
                    color: AppColors.activeButtonColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
