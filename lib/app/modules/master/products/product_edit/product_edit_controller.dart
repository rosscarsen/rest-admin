import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config.dart';
import '../../../../model/category_model.dart';
import '../../../../model/product_action_init_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/easy_loading.dart';
import 'product_edit_fields.dart';

class ProductEditController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ApiClient apiClient = ApiClient();
  final isLoading = true.obs;
  final title = "".obs;
  late final TabController tabController;
  List<Tab> tabs = <Tab>[
    Tab(text: LocaleKeys.product.tr),
    Tab(text: LocaleKeys.detail.tr),
    Tab(text: LocaleKeys.barcode.tr),
    Tab(text: LocaleKeys.shop.tr),
  ];
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  final category3 = <CategoryModel>[].obs;

  @override
  void onInit() {
    initParams();
    getCategories();
    super.onInit();
  }

  void initParams() {
    final params = Get.parameters;
    title.value = params.isEmpty
        ? "${LocaleKeys.add.tr}${LocaleKeys.product.tr}"
        : "${LocaleKeys.edit.tr}${LocaleKeys.product.tr}";
    if (params.isNotEmpty) {
      tabs.add(Tab(text: LocaleKeys.setMealLimit.tr));
      tabs.add(Tab(text: LocaleKeys.setMeal.tr));
    }
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onReady() {
    final params = Get.parameters;
    var format = DateFormat("yyyy-MM-dd");
    if (params.isEmpty) {
      formKey.currentState?.patchValue({
        ProductEditFields.mDateCreate: format.format(DateTime.now()),
        ProductEditFields.mDateModify: format.format(DateTime.now()),
      });
    }
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void generateCategory2(String? selectCate1) {
    category2.clear();
    category3.clear();
    formKey.currentState?.fields[ProductEditFields.mCategory1]?.didChange("");

    if (selectCate1 == null || selectCate1.isEmpty) return;
    final parent = category1.firstWhereOrNull((e) => e.mCategory == selectCate1);
    if (parent != null && parent.children != null) {
      category2.assignAll(parent.children!);
    }
  }

  Future<void> getCategories() async {
    isLoading(true);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.productActionInit);

      if (!dioApiResult.success && dioApiResult.hasPermission) {
        showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (!dioApiResult.hasPermission) {
        showToast(LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data == null) {
        showToast(LocaleKeys.dataException.tr);
        return;
      }

      final advancedSearchModel = productActionInitModelFromJson(dioApiResult.data!);
      if (advancedSearchModel.apiResult == null) {
        return;
      }
      //类目
      final categories = advancedSearchModel.apiResult?.category;
      if (categories != null && categories.isNotEmpty) {
        category1.assignAll(categories);
      }
      /* //部门
      final departments = advancedSearchModel.apiResult?.department;
      if (departments != null && departments.isNotEmpty) {
        department.assignAll(departments);
      } */
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
