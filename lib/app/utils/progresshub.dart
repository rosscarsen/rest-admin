import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProgressHUD extends StatelessWidget {
  final Widget? child;
  final double? opacity;
  final Color color;
  final Animation<Color>? valueColor;

  const ProgressHUD({super.key, required this.child, this.opacity = 1, this.color = Colors.white, this.valueColor});

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      final modal = Stack(
        children: [
          Opacity(opacity: opacity!, child: ModalBarrier(dismissible: false, color: color)),
          Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.blue, size: 63)),
        ],
      );
      return modal;
    } else {
      return child!;
    }
  }
}
