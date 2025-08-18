import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../config.dart';
import '../../../../../model/category/category_all_model.dart';
import '../../../../../model/category/category_model.dart';
import '../../../../../model/product/copy_product_set_meal.dart';
import '../../../../../service/dio_api_client.dart';
import '../../../../../service/dio_api_result.dart';
import '../../../../../translations/locale_keys.dart';
import '../../../../../utils/custom_dialog.dart';
import '../../../../../utils/logger.dart';
import 'copy_product_set_meal_source.dart';

class CopyProductSetMealController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController keyWordController = TextEditingController();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<ProductSetMealData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late CopyProductSetMealDataSource dataSource;
  // 类目
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  @override
  void onInit() {
    fetchMultipleData().then((_) {
      dataSource = CopyProductSetMealDataSource(this);
    });
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    super.onClose();
  }

  //重载数据
  void reloadData() {
    dataGridController.selectedRows = [];
    formKey.currentState?.saveAndValidate();
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
    updateDataGridSource();
  }

  //更新数据源
  void updateDataGridSource() {
    getProductSetMeal().then((_) {
      dataSource = CopyProductSetMealDataSource(this);
    });
  }

  /// 生成二级类目
  void generateCategory2(String? selectCate1) {
    category2.clear();
    formKey.currentState?.fields["mCategory2"]?.didChange("");
    if (selectCate1 == null || selectCate1.isEmpty) return;
    final parent = category1.firstWhereOrNull((e) => e.mCategory == selectCate1);
    if (parent != null && parent.children != null) {
      category2.assignAll(parent.children!);
    }
  }

  ///获取产品列表
  Future<void> getProductSetMeal() async {
    isLoading(true);
    DataList.clear();
    try {
      Map<String, dynamic> search = {'page': currentPage.value};
      if (formKey.currentState?.value != null) {
        search.addAll(formKey.currentState?.value ?? {});
      }
      logger.f(search);
      final DioApiResult dioApiResult = await apiClient.post(Config.openProductSetMeal, data: search);

      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (!dioApiResult.hasPermission) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final productsSetMealModel = copyProductSetMealModelFromJson(dioApiResult.data!);
      if (productsSetMealModel.status == 200) {
        DataList = productsSetMealModel.apiResult?.data ?? [];
        totalPages.value = (productsSetMealModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (productsSetMealModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }

  /// 获取产品列表和类目列表
  Future<void> fetchMultipleData() async {
    isLoading(true);
    Map<String, Object> search = {'page': currentPage.value};
    final futures = [
      apiClient.post(Config.openProductSetMeal, data: search),
      apiClient.post(Config.categories, data: {"checkPermission": false}),
    ];

    try {
      final results = await Future.wait(futures);
      for (int i = 0; i < results.length; i++) {
        // 产品列表
        if (i == 0) {
          final DioApiResult productDioApiResult = results[i];

          if (!productDioApiResult.success) {
            CustomDialog.showToast(productDioApiResult.error ?? LocaleKeys.unknownError.tr);
            continue;
          }
          if (!productDioApiResult.hasPermission) {
            CustomDialog.showToast(productDioApiResult.error ?? LocaleKeys.noPermission.tr);
            continue;
          }
          if (productDioApiResult.data == null) {
            CustomDialog.showToast(productDioApiResult.error ?? LocaleKeys.unknownError.tr);
            continue;
          }
          final productsSetMealModel = copyProductSetMealModelFromJson(productDioApiResult.data!);

          if (productsSetMealModel.status == 200) {
            DataList = productsSetMealModel.apiResult?.data ?? [];
            totalPages.value = (productsSetMealModel.apiResult?.lastPage ?? 0);
            totalRecords.value = (productsSetMealModel.apiResult?.total ?? 0);
          } else {
            CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
          }
        }
        // 类目
        if (i == 1) {
          final DioApiResult categoryDioApiResult = results[i];
          if (!categoryDioApiResult.success) {
            continue;
          }
          if (!categoryDioApiResult.hasPermission) {
            continue;
          }
          if (categoryDioApiResult.data == null) {
            continue;
          }
          final categoriesModel = categoryAllModelFromJson(categoryDioApiResult.data!);
          if (categoriesModel.status == 200) {
            category1.assignAll(categoriesModel.apiResult ?? []);
          } else {
            //CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
            debugPrint("类目获取失败");
          }
        }
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }
}
