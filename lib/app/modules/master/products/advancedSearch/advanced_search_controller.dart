import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../config.dart';
import '../../../../model/advanced_search_model.dart';
import '../../../../model/category_model.dart';
import '../../../../model/department_model.dart';
import '../../../../service/api_client.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/easy_loding.dart';
import 'advanced_search_fields.dart';

class AdvancedSearchController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final isLoading = true.obs;
  final ApiClient apiClient = ApiClient();
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  final category3 = <CategoryModel>[].obs;
  final department = <DepartmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCategories().then((value) {
      final Map<String, dynamic> oldFormData = Get.arguments is Map ? Get.arguments : {};

      if (oldFormData.isNotEmpty) {
        final selectCate1 = oldFormData[AdvancedSearchFields.mCategory1]?.toString() ?? "";
        final selectCate2 = oldFormData[AdvancedSearchFields.mCategory2]?.toString() ?? "";
        final selectCate3 = oldFormData[AdvancedSearchFields.mCategory3]?.toString() ?? "";

        if (selectCate1.isNotEmpty) {
          generateCategory2(selectCate1);
        }
        if (selectCate2.isNotEmpty) {
          generateCategory3(selectCate2);
        }
        if (selectCate3.isNotEmpty) {
          generateCategory3(selectCate2);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final fields = formKey.currentState?.fields;
          if (fields != null) {
            fields.forEach((fieldName, fieldState) {
              if (oldFormData.containsKey(fieldName)) {
                fieldState.didChange(oldFormData[fieldName]);
              }
            });
          }
        });
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  void generateCategory2(String? selectCate1) {
    category2.clear();
    category3.clear();
    formKey.currentState?.fields[AdvancedSearchFields.mCategory2]?.didChange("");
    formKey.currentState?.fields[AdvancedSearchFields.mCategory3]?.didChange("");
    if (selectCate1 == null || selectCate1.isEmpty) return;

    final parent = category1.firstWhereOrNull((e) => e.mCategory == selectCate1);
    if (parent != null && parent.children != null) {
      category2.assignAll(parent.children!);
    }
  }

  void generateCategory3(String? selectCate2) {
    formKey.currentState?.fields[AdvancedSearchFields.mCategory3]?.didChange("");
    category3.clear();
    if (selectCate2 == null || selectCate2.isEmpty) return;

    final parent = category2.firstWhereOrNull((e) => e.mCategory == selectCate2);
    if (parent != null && parent.children != null) {
      category3.assignAll(parent.children!);
    }
  }

  Future<void> getCategories() async {
    isLoading(true);
    try {
      final String? jsonString = await apiClient.post(Config.productadvancedSearch);

      if (jsonString?.isEmpty ?? true) {
        return;
      }
      if (jsonString == Config.noPermission) {
        showToast(LocaleKeys.noPermission.tr);
        return;
      }
      final advancedSearchModel = advancedSearchModelFromJson(jsonString!);
      //类目
      final categories = advancedSearchModel.category;
      if (categories != null && categories.isNotEmpty) {
        category1.assignAll(categories);
      }
      //部门
      final departments = advancedSearchModel.department;
      if (departments != null && departments.isNotEmpty) {
        department.assignAll(departments);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
