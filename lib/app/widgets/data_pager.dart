import 'package:flutter/material.dart';
import 'package:flutter_number_pagination/flutter_number_pagination.dart';
import 'package:get/get.dart';

class DataPager extends StatelessWidget {
  const DataPager({super.key, required this.totalPages, required this.currentPage, required this.onPageChanged});

  final RxInt totalPages; // 使用 RxInt 替代 int
  final RxInt currentPage; // 使用 RxInt 替代 int
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (totalPages.value == 0) return const SizedBox();
      return NumberPagination(
        key: ValueKey(currentPage.value),
        onPageChanged: onPageChanged,
        pageTotal: totalPages.value,
        pageInit: currentPage.value,
        colorPrimary: Theme.of(context).colorScheme.primary,
        colorSub: Colors.white,
        threshold: context.isPhoneOrLess ? 3 : 10,
      );
    });
  }
}
