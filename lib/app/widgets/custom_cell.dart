import 'package:flutter/material.dart';

class CustomCell extends StatelessWidget {
  const CustomCell({super.key, this.data, this.alignment = Alignment.centerLeft, this.ellipsis = true, this.child});

  final String? data;
  final AlignmentGeometry? alignment;
  final bool ellipsis;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Container(padding: const EdgeInsets.symmetric(horizontal: 8.0), alignment: alignment, child: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final text = data ?? "";
        final textStyle = DefaultTextStyle.of(context).style;

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        final textWidget = Text(text, textAlign: TextAlign.center, overflow: ellipsis ? TextOverflow.ellipsis : null);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          alignment: alignment,
          child: isOverflowing ? Tooltip(message: text, child: textWidget) : textWidget,
        );
      },
    );
  }
}
