import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title, this.leadingWidget});
  final String title;
  final Widget? leadingWidget;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingWidget,
      title: Text(title),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 67, 167, 230), Color(0xFFbee4ff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
