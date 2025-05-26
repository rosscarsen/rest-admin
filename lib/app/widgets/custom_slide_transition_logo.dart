import 'package:flutter/material.dart';

///logo动画
class CustomSlideTransitionLogo extends StatefulWidget {
  const CustomSlideTransitionLogo({
    super.key,
    this.height = 200,
    required this.logo,
  });
  final double? height;
  final String logo;
  @override
  State<CustomSlideTransitionLogo> createState() =>
      _CustomSlideTransitionLogoState();
}

class _CustomSlideTransitionLogoState extends State<CustomSlideTransitionLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(begin: Offset.zero, end: const Offset(0, -0.1)).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.linear)),
      child: SafeArea(
        child: Container(
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.logo), fit: BoxFit.fitHeight),
          ),
        ),
      ),
    );
  }
}
