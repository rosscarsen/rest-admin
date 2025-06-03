import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_scaffold.dart';
import 'category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.CATEGORY,
      body: Center(child: Text(LocaleKeys.category.tr, style: TextStyle(fontSize: 20))),
      title: LocaleKeys.category.tr,
    );
  }
}
