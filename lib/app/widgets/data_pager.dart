import 'package:flutter/material.dart';
import 'package:flutter_number_pagination/flutter_number_pagination.dart';
import 'package:get/get.dart';

import '../translations/locale_keys.dart';

class DataPager extends StatelessWidget {
  const DataPager({
    super.key,
    required this.totalPages,
    required this.totalRecords,
    required this.currentPage,
    required this.onPageChanged,
  });

  final RxInt totalPages; // 使用 RxInt 替代 int
  final RxInt totalRecords; // 使用 RxInt 替代 int
  final RxInt currentPage; // 使用 RxInt 替代 int
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (totalPages.value == 0) return const SizedBox();
      return Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(border: Border(top: Divider.createBorderSide(context, width: 1.0))),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                children: [
                  NumberPagination(
                    key: ValueKey(currentPage.value),
                    onPageChanged: onPageChanged,
                    pageTotal: totalPages.value,
                    pageInit: currentPage.value,
                    colorPrimary: Theme.of(context).colorScheme.primary,
                    colorSub: Colors.white,
                    threshold: context.isPhoneOrLess ? 3 : 10,
                  ),
                  FittedBox(
                    child: Text(
                      LocaleKeys.totalRecords.trArgs([totalRecords.value.toString()]),
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
