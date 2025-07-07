import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../config.dart';
import '../../../../model/category_model.dart';
import '../../../../model/product_add_or_edit_model.dart';
import '../../../../model/unit_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/easy_loading.dart';
import '../../../../utils/logger.dart';
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
  final hasPermission = true.obs;
  final units = <UnitModel>[].obs;

  @override
  void onInit() {
    initParams();

    productAddOrEdit();
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
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void generateCategory2(String? selectCate1) {
    category2.clear();
    formKey.currentState?.fields[ProductEditFields.mCategory2]?.didChange("");
    if (selectCate1 == null || selectCate1.isEmpty) return;
    final parent = category1.firstWhereOrNull((e) => e.mCategory == selectCate1);
    if (parent != null && parent.children != null) {
      category2.assignAll(parent.children!);
    }
  }

  /// 获取单个产品数据
  Future<void> productAddOrEdit() async {
    isLoading(true);
    try {
      final query = Get.parameters;
      final DioApiResult dioApiResult = await apiClient.post(Config.productAddOrEdit, data: query);

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (dioApiResult.data == null) {
        showToast(LocaleKeys.dataException.tr);
        return;
      }
      hasPermission.value = true;
      final result = productAddOrEditModelFromJson(dioApiResult.data!);
      final apiResult = result.apiResult;
      if (apiResult != null) {
        final categories = apiResult.category;
        if (categories?.isNotEmpty ?? false) {
          category1.assignAll(categories!);
        }
        if (apiResult.productInfo != null) {
          logger.i("apiResult.productInfo:${apiResult.productInfo!.toJson()}");
          final productInfo = apiResult.productInfo;
          if (productInfo != null) {
            formKey.currentState?.patchValue(
              Map.fromEntries(apiResult.productInfo!.toJson().entries.where((e) => e.value != null)),
            );
          }
          units.assignAll(apiResult.units ?? []);
        }
      }

      /* 
      //类目
      final categories = advancedSearchModel.apiResult?.category;
      if (categories != null && categories.isNotEmpty) {
        category1.assignAll(categories);
      } */
    } catch (e) {
      logger.i(e.toString());
      showToast(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }
}
