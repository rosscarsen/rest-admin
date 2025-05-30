import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rest_admin/app/routes/app_pages.dart';
import 'package:rest_admin/app/translations/locale_keys.dart';
import 'package:rest_admin/app/widgets/custom_scaffold.dart';

import 'category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.CATEGORY,
      body: const Center(child: Text('CategoryView is working', style: TextStyle(fontSize: 20))),
      title: LocaleKeys.category.tr,
    );
  }
}
