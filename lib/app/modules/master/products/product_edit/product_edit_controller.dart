import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../config.dart';
import '../../../../model/category_model.dart';
import '../../../../model/product_add_or_edit_model.dart';
import '../../../../model/unit_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/logger.dart';
import 'product_barcode_source.dart';
import 'product_edit_fields.dart';
import 'product_set_meal_limit_source.dart';
import 'product_stock_source.dart';

class ProductEditController extends GetxController with GetSingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> productEditFormKey = GlobalKey<FormBuilderState>();
  // 产品条码
  final DataGridController barcodeDataGridController = DataGridController();
  late ProductBarcodeSource productBarcodeSource;
  final productBarcode = <ProductBarcode>[].obs;
  // 产品仓库
  final DataGridController stockDataGridController = DataGridController();
  late ProductStockSource productStockSource;
  final productStock = <ProductStock>[].obs;
  // 套餐限制
  final DataGridController setMealLimitDataGridController = DataGridController();
  late SetMealLimitSource setMealLimitSource;
  final setMealLimit = <SetMealLimit>[].obs;
  // Dio客户端
  final ApiClient apiClient = ApiClient();
  // 加载标识
  final isLoading = true.obs;
  // 页面标题
  final title = "".obs;
  // tab控制器
  late final TabController tabController;
  List<Tab> tabs = [
    Tab(text: LocaleKeys.product.tr),
    Tab(text: LocaleKeys.detail.tr),
    Tab(text: LocaleKeys.barcode.tr),
    Tab(text: LocaleKeys.shop.tr),
  ];
  final tabIndex = 0.obs;
  // 类目
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  // 权限
  final hasPermission = true.obs;
  // 单位
  final units = <UnitModel>[].obs;
  // 全部类目用于多选类目
  final categories = <CategoryModel>[].obs;

  //产品ID
  int? productID;
  //多类
  RxList productCategory3 = [].obs;
  @override
  void onInit() {
    initParams();
    updateDataGridSource();
    super.onInit();
  }

  /// 重置状态
  void restState() {
    productEditFormKey.currentState?.reset();
  }

  /// 初始化参数
  void initParams() {
    final params = Get.arguments as Map<String, dynamic>?;
    productID = int.tryParse(params?["id"] ?? "");

    if (productID != null) {
      tabs.add(Tab(text: LocaleKeys.setMealLimit.tr));
      tabs.add(Tab(text: LocaleKeys.setMeal.tr));
    }
    title.value = productID == null
        ? "${LocaleKeys.add.tr}${LocaleKeys.product.tr}"
        : "${LocaleKeys.edit.tr}${LocaleKeys.product.tr}";

    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }

  //更新数据源
  void updateDataGridSource() {
    restState();
    productAddOrEdit().then((_) {
      productBarcodeSource = ProductBarcodeSource(this);
      productStockSource = ProductStockSource(this);
      setMealLimitSource = SetMealLimitSource(this);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    barcodeDataGridController.dispose();
    stockDataGridController.dispose();
    setMealLimitDataGridController.dispose();
    super.onClose();
  }

  /// 生成二级类目
  void generateCategory2(String? selectCate1) {
    category2.clear();
    productEditFormKey.currentState?.fields[ProductEditFields.mCategory2]?.didChange("");
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
      final DioApiResult dioApiResult = await apiClient.post(Config.productAddOrEdit, data: {'id': productID});

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (dioApiResult.data == null) {
        CustomDialog.showToast(LocaleKeys.dataException.tr);
        return;
      }
      hasPermission.value = true;
      final result = productAddOrEditModelFromJson(dioApiResult.data!);
      final apiResult = result.apiResult;
      if (apiResult != null) {
        categories.value = apiResult.category ?? [];
        if (categories.isNotEmpty) {
          category1.assignAll(categories);
        }
        if (apiResult.productInfo != null) {
          final productInfo = apiResult.productInfo;
          if (productInfo != null) {
            productCategory3.value = productInfo.mCategory3?.split(",") ?? [];
            productEditFormKey.currentState?.patchValue(
              Map.fromEntries(apiResult.productInfo!.toJson().entries.where((e) => e.value != null)),
            );
          }
          productBarcode.assignAll(apiResult.productBarcode ?? []);
          productStock.assignAll(apiResult.productStock ?? []);
          setMealLimit.assignAll(apiResult.setMealLimit ?? []);

          units.assignAll(apiResult.units ?? []);
        }
      }
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.showToast(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }

  /// 保存产品
  Future<void> productAddOrEditSave() async {
    if (productEditFormKey.currentState?.saveAndValidate() ?? false) {
      // 保存的時候要去除“平均成本”与“最后成本”
      // 创建与修改时间为当前时间

      final formData = Map<String, dynamic>.from(productEditFormKey.currentState!.value);
      final selectedMultipleCategory = formData.entries
          .where((e) => e.key.startsWith('multipleCategory_'))
          .expand((e) => e.value ?? [])
          .toList();

      formData['category3'] = selectedMultipleCategory.isEmpty ? null : selectedMultipleCategory.join(",");
      formData.removeWhere((key, value) => key.startsWith('multipleCategory_'));

      formData['T_Product_ID'] = productID;
      // 条码
      formData.addAll({
        'productBarcode': productBarcode.isNotEmpty
            ? productBarcode.map((e) {
                final json = Map<String, dynamic>.from(e.toJson());
                json.remove('T_Product_ID');
                return json;
              }).toList()
            : [],
      });
      // 套餐限制
      formData.addAll({
        'setMealLimit': setMealLimit.isNotEmpty
            ? setMealLimit.map((e) {
                final json = Map<String, dynamic>.from(e.toJson());
                json.remove('set_limit_id');
                json.remove('t_product_id');
                return json;
              }).toList()
            : [],
      });
      logger.e(formData);
      final DioApiResult dioApiResult = await apiClient.post(Config.productAddOrEditSave, data: formData);
      logger.f(dioApiResult);
    }
  }

  /// 编辑或添加产品条码
  Future<void> editOrAddProductBarcode({ProductBarcode? row}) async {
    final formKey = GlobalKey<FormState>();
    final bool isAdd = row == null;
    row ??= ProductBarcode();
    Get.defaultDialog(
      title: isAdd ? LocaleKeys.barcodeAdd.tr : LocaleKeys.barcodeEdit.tr,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            TextFormField(
              initialValue: row.mCode,
              decoration: InputDecoration(labelText: LocaleKeys.code.tr),
              onChanged: (value) {
                row?.mCode = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.thisFieldIsRequired.tr;
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: row.mName,
              decoration: InputDecoration(labelText: LocaleKeys.name.tr),
              onChanged: (value) {
                row?.mName = value;
              },
            ),
            DropdownButtonFormField(
              value: row.mNonActived?.toString() ?? "0",
              items: [
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
              onChanged: (value) {
                row?.mNonActived = int.tryParse(value ?? "0");
              },
            ),
            TextFormField(
              initialValue: row.mRemarks,
              decoration: InputDecoration(labelText: LocaleKeys.remarks.tr),
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                row?.mRemarks = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.closeDialog();
          },
          child: Text(LocaleKeys.cancel.tr),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              CustomDialog.successMessages(isAdd ? LocaleKeys.addSuccess.tr : LocaleKeys.editSuccess.tr);
              if (isAdd && row != null) {
                row.mName = row.mName ?? "";
                row.mNonActived = row.mNonActived ?? 0;
                row.mRemarks = row.mName ?? "";
                row.mItem = productBarcode.length + 1;
                productBarcode.insert(0, row);
              }
              productBarcodeSource.updateDataSource();
              Get.closeDialog();
            }
          },
          child: Text(isAdd ? LocaleKeys.add.tr : LocaleKeys.edit.tr),
        ),
      ],
    );
  }

  /// 删除产品条码
  Future<void> deleteProductBarcode({ProductBarcode? row}) async {
    if (row == null) return;
    productBarcode.remove(row);
    productBarcodeSource.updateDataSource();
  }
}
