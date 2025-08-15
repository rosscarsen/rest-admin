import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../model/categories_model.dart';
import '../../../model/category_model.dart';
import '../../../model/product_add_or_edit_model.dart';
import '../../../model/products_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/logger.dart';
import '../../master/products/product_edit/product_edit_controller.dart';
import 'open_multiple_products_data_source.dart';

class OpenMultipleProductController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  static OpenMultipleProductController get to => Get.find();
  final GlobalKey<FormBuilderState> openMultipleProductFormKey = GlobalKey<FormBuilderState>();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<ProductData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenMultipleProductsDataSource dataSource;
  String mStep = "1";
  // 类目
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  @override
  void onInit() {
    fetchMultipleData().then((_) {
      dataSource = OpenMultipleProductsDataSource(this);
    });
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    dataSource.dispose();
    super.onClose();
  }

  //重载数据
  void reloadData() {
    dataGridController.selectedRows = [];
    openMultipleProductFormKey.currentState?.saveAndValidate();
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
    updateDataGridSource();
  }

  //更新数据源
  void updateDataGridSource() {
    getProduct().then((_) {
      dataSource = OpenMultipleProductsDataSource(this);
    });
  }

  /// 生成二级类目
  void generateCategory2(String? selectCate1) {
    category2.clear();
    openMultipleProductFormKey.currentState?.fields["mCategory2"]?.didChange("");
    if (selectCate1 == null || selectCate1.isEmpty) return;
    final parent = category1.firstWhereOrNull((e) => e.mCategory == selectCate1);
    if (parent != null && parent.children != null) {
      category2.assignAll(parent.children!);
    }
  }

  ///获取产品列表
  Future<void> getProduct() async {
    isLoading(true);
    DataList.clear();
    try {
      Map<String, dynamic> search = {'page': currentPage.value, "byCode": "asc"};
      if (openMultipleProductFormKey.currentState?.value != null) {
        search.addAll(openMultipleProductFormKey.currentState?.value ?? {});
      }
      logger.f(search);
      final DioApiResult dioApiResult = await apiClient.post(Config.openProduct, data: search);

      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (!dioApiResult.hasPermission) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final productsModel = productsModelFromJson(dioApiResult.data!);
      if (productsModel.status == 200) {
        DataList = productsModel.apiResult?.productData ?? [];
        totalPages.value = (productsModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (productsModel.apiResult?.total ?? 0);
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
    Map<String, Object> search = {'page': currentPage.value, "byCode": "asc"};
    final futures = [
      apiClient.post(Config.openProduct, data: search),
      apiClient.post(Config.categories, data: {"checkPermission": false}),
    ];

    try {
      final results = await Future.wait(futures);
      for (int i = 0; i < results.length; i++) {
        // 产品列表
        if (i == 0) {
          final DioApiResult productDioApiResult = results[i];

          if (!productDioApiResult.success) {
            CustomDialog.errorMessages(productDioApiResult.error ?? LocaleKeys.unknownError.tr);
            continue;
          }
          if (!productDioApiResult.hasPermission) {
            CustomDialog.errorMessages(productDioApiResult.error ?? LocaleKeys.noPermission.tr);
            continue;
          }
          if (productDioApiResult.data == null) {
            CustomDialog.errorMessages(productDioApiResult.error ?? LocaleKeys.unknownError.tr);
            continue;
          }
          final productsModel = productsModelFromJson(productDioApiResult.data!);

          if (productsModel.status == 200) {
            DataList = productsModel.apiResult?.productData ?? [];
            totalPages.value = (productsModel.apiResult?.lastPage ?? 0);
            totalRecords.value = (productsModel.apiResult?.total ?? 0);
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
          final categoriesModel = categoriesModelFromJson(categoryDioApiResult.data!);
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

  /// 加入套餐
  Future<void> joinSetMeal() async {
    final productCtl = Get.find<ProductEditController>();
    final oldSetMealCodes = productCtl.productSetMeal.map((e) => e.mBarcode).toSet().toList();

    if (dataGridController.selectedRows.isEmpty) {
      CustomDialog.errorMessages(LocaleKeys.pleaseSelectOneDataOrMore.tr);
      return;
    }

    final selectedRows = dataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      CustomDialog.errorMessages(LocaleKeys.pleaseSelectOneDataOrMore.tr);
      return;
    }
    final selectProductCodes = selectedRows
        .map((row) => row.getCells().firstWhereOrNull((cell) => cell.columnName == "code")?.value)
        .whereType<String>()
        .where((element) => element.trim().isNotEmpty)
        .toSet()
        .toList();
    final commonCodes = selectProductCodes.toSet().intersection(oldSetMealCodes.toSet()).toList();
    final lastSelectProductCodes = List.from(selectProductCodes);
    if (commonCodes.isNotEmpty) {
      await CustomAlert.iosAlert(
        "${LocaleKeys.theSelectedContentAlreadyExists.tr}:${commonCodes.join(",")}",
        showCancel: true,
        cancelText: LocaleKeys.ignore.tr,
        confirmText: LocaleKeys.skip.tr,
        onConfirm: () {
          lastSelectProductCodes.clear();
          lastSelectProductCodes.addAll(selectProductCodes.toSet().difference(oldSetMealCodes.toSet()).toList());
        },
      );
    }
    selectProductCodes.clear();
    if (lastSelectProductCodes.isEmpty) {
      Get.back();
      return;
    }
    final parameters = Get.parameters;
    if (parameters["productId"] == null) {
      CustomDialog.errorMessages(LocaleKeys.exception.tr);
      return;
    }
    final query = {
      "productId": parameters["productId"],
      "mStep": mStep,
      "selectProductCodes": lastSelectProductCodes.toSet().toList(),
    };
    CustomDialog.showLoading(LocaleKeys.joining.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.addProductSetMeal, data: query);
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(LocaleKeys.dataException.tr);
        return;
      }
      final Map<String, dynamic> data = jsonDecode(dioApiResult.data) ?? {};
      if (data.isNotEmpty) {
        if (data["status"] == 200) {
          final List<dynamic>? apiProductList = data["apiResult"];
          if (apiProductList != null) {
            productCtl.productSetMeal
              ..clear()
              ..addAll(apiProductList.map((e) => ProductSetMeal.fromJson(e)).toList());
            productCtl.productSetMealSource.updateDataSource();
            CustomDialog.successMessages(LocaleKeys.joinSuccess.tr);
            Get.back();
          } else {
            CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
          }
        } else {
          CustomDialog.errorMessages(LocaleKeys.joinFailed.tr);
        }
      } else {
        CustomDialog.showToast(LocaleKeys.joinFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.joinFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }
}
