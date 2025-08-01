import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../translations/locale_keys.dart';

class NoRecord extends StatelessWidget {
  const NoRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.thumb_down_alt_outlined, size: 30),
            SizedBox(height: 8),
            Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
