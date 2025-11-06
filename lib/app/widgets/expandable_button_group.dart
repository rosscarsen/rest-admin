import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableButtonGroup extends StatefulWidget {
  final List<Widget> buttons;

  /// “更多操作”的文字
  final String moreText;

  /// 按钮间距
  final double spacing;

  /// 行间距（expanded 时）
  final double runSpacing;

  /// 展开区域的 padding
  final EdgeInsets expandedPadding;

  /// header 高度
  final double headerHeight;
  const ExpandableButtonGroup({
    super.key,
    required this.buttons,
    this.moreText = 'More Operation',
    this.spacing = 5,
    this.runSpacing = 5,
    this.expandedPadding = const EdgeInsets.symmetric(vertical: 3.0),
    this.headerHeight = 44,
  });

  @override
  State<ExpandableButtonGroup> createState() => _ExpandableButtonGroupState();
}

class _ExpandableButtonGroupState extends State<ExpandableButtonGroup> {
  late final ExpandableController _controller;
  late final ScrollController _scrollController;
  bool hasIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController(initialExpanded: false);
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  void didUpdateWidget(covariant ExpandableButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final shouldHaveIcon = maxScroll > 0; // 内容比可视宽度更宽

    if (shouldHaveIcon != hasIcon) {
      setState(() {
        hasIcon = shouldHaveIcon;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: _controller,
      child: ScrollOnExpand(
        scrollOnExpand: true,
        scrollOnCollapse: false,
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapHeaderToExpand: true,
            tapBodyToExpand: false,
            tapBodyToCollapse: false,
            hasIcon: hasIcon,
            useInkWell: false,
            iconColor: Color(0xFF1890FF),
          ),
          controller: _controller,
          collapsed: const SizedBox.shrink(),

          header: ValueListenableBuilder<bool>(
            valueListenable: _controller,
            builder: (BuildContext context, bool expanded, Widget? child) {
              if (expanded) {
                return Text(widget.moreText, style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600));
              } else {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(spacing: widget.spacing, children: widget.buttons),
                      ),
                    );
                  },
                );
              }
            },
          ),
          expanded: Padding(
            padding: widget.expandedPadding,
            child: Wrap(
              spacing: widget.spacing,
              runSpacing: widget.runSpacing,
              children: widget.buttons.map((button) {
                if (button is ElevatedButton) {
                  // 保留原始按钮的行为
                  final onPressed = button.onPressed;
                  return ElevatedButton(
                    onPressed: () {
                      _controller.toggle();
                      onPressed?.call();
                    },
                    child: button.child,
                  );
                } else {
                  // 如果传入的不是 ElevatedButton，直接使用
                  return GestureDetector(onTap: _controller.toggle, child: button);
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
