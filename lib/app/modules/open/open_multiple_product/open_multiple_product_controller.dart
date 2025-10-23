import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/category/category_all_model.dart';
import '../../../model/category/category_model.dart';
import '../../../model/product/product_add_or_edit_model.dart';
import '../../../model/product/products_model.dart';
import '../../../model/supplierInvoice/supplier_invoice_api_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/logger.dart';
import '../../master/products/product_edit/product_edit_controller.dart';
import '../../supplier_invoice/supplier_invoice_edit/supplier_invoice_edit_controller.dart';
import 'open_multiple_products_data_source.dart';

class OpenMultipleProductController extends GetxController with LoadingStateMixin {
  final DataGridController dataGridController = DataGridController();
  static OpenMultipleProductController get to => Get.find();
  final GlobalKey<FormBuilderState> openMultipleProductFormKey = GlobalKey<FormBuilderState>();

  final ApiClient apiClient = ApiClient();
  late OpenMultipleProductsDataSource dataSource;
  String mStep = "1";
  // 类目
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  // 从哪个页面调用
  late final String target;

  List<ProductData> DataList = [];

  /// 选中的产品
  List<ProductData> selectedItems = [];
  @override
  void onInit() {
    super.onInit();
    target = Get.parameters["target"] ?? "";
    fetchMultipleData().then((_) {
      dataSource = OpenMultipleProductsDataSource(this);
    });
  }

  @override
  void onClose() {
    dataGridController.dispose();
    selectedItems.clear();
    DataList.clear();
    super.onClose();
  }

  //重载数据
  void reloadData() {
    openMultipleProductFormKey.currentState?.saveAndValidate();
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages = 0;
    currentPage = 1;
    updateDataGridSource();
  }

  //更新数据源
  void updateDataGridSource() {
    dataGridController.selectedRows = [];
    getProduct().then((_) {
      dataSource = OpenMultipleProductsDataSource(this);
      setInitialSelectedRows();
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
    isLoading = true;
    DataList.clear();
    try {
      Map<String, dynamic> search = {'page': currentPage, "byCode": "asc"};
      if (openMultipleProductFormKey.currentState?.value != null) {
        search.addAll(openMultipleProductFormKey.currentState?.value ?? {});
      }
      logger.f(search);
      final DioApiResult dioApiResult = await apiClient.get(Config.openProduct, data: search);

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
        totalPages = (productsModel.apiResult?.lastPage ?? 0);
        totalRecords = (productsModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading = false;
    }
  }

  /// 获取产品列表和类目列表
  Future<void> fetchMultipleData() async {
    isLoading = true;
    Map<String, Object> search = {'page': currentPage, "byCode": "asc"};
    final futures = [apiClient.post(Config.openProduct, data: search), apiClient.post(Config.openCategory)];

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
            totalPages = (productsModel.apiResult?.lastPage ?? 0);
            totalRecords = (productsModel.apiResult?.total ?? 0);
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
      isLoading = false;
    }
  }

  /// 初始化选中的行
  void setInitialSelectedRows() {
    final selectedCodes = selectedItems.map((e) => e.mCode).whereType<String>().toList();
    final rowsToSelect = selectedCodes.map((code) => dataSource.findRowByCode(code)).whereType<DataGridRow>().toList();
    dataGridController.selectedRows = rowsToSelect;
  }

  /// 加入选中的产品
  Future<void> joinSelected() async {
    final selectedCodes = selectedItems.map((e) => e.mCode).toList();
    if (selectedCodes.isEmpty) {
      CustomDialog.errorMessages(LocaleKeys.pleaseSelectOneDataOrMore.tr);
      return;
    }
    switch (target) {
      case "addSetMeal": //加入套餐
        await joinSetMeal();
        break;
      case "supplierInvoiceAddItem": //加入发票项目
        await joinSupplierInvoiceAddItem();
        break;
      default:
        await joinDefaultSelectedItems();
        break;
    }
  }

  /// 加入或移除选中的产品
  void addSelectedItems(List<DataGridRow> rows, bool isAdd) {
    final selectCodes = rows
        .map((row) => row.getCells().firstWhereOrNull((cell) => cell.columnName == "code")?.value)
        .whereType<String>()
        .where((element) => element.trim().isNotEmpty)
        .toSet()
        .toList();
    if (isAdd) {
      for (final e in DataList) {
        if (selectCodes.contains(e.mCode) && !selectedItems.any((item) => item.mCode == e.mCode)) {
          selectedItems.add(e);
        }
      }
    } else {
      selectedItems.removeWhere((e) => selectCodes.contains(e.mCode));
    }
  }

  /// 默認加入选中的产品
  Future<void> joinDefaultSelectedItems() async {
    final selectCodes = selectedItems.map((e) => e.mCode).toSet();
    Get.back(result: selectCodes.join(","));
  }

  /// 加入供应商发票项目
  Future<void> joinSupplierInvoiceAddItem() async {
    final preCtl = Get.find<SupplierInvoiceEditController>();
    final oldCodes = preCtl.invoiceDetail.map((e) => e.mProductCode).toSet();
    final selectCodes = selectedItems.map((e) => e.mCode).toSet();
    final commonCodes = selectCodes.intersection(oldCodes).toList();
    final defaultStock = Get.parameters["defaultStock"] ?? "";
    if (commonCodes.isNotEmpty) {
      await CustomAlert.iosAlert(
        message: "${LocaleKeys.theSelectedContentAlreadyExists.tr}:${commonCodes.join(",")}",
        showCancel: true,
        cancelText: LocaleKeys.ignore.tr,
        confirmText: LocaleKeys.skip.tr,
        onConfirm: () {
          selectedItems.removeWhere((e) => commonCodes.contains(e.mCode));
          logger.f(selectedItems);
        },
      );
    }
    if (selectedItems.isEmpty) {
      Get.back();
      return;
    }
    // 保存初始长度
    final initialLength = preCtl.invoiceDetail.length;
    final firstInvoiceId = preCtl.id ?? "";

    // 使用asMap()获取索引，避免indexOf的性能开销
    preCtl.invoiceDetail.addAll(
      selectedItems.asMap().entries.map((entry) {
        final index = entry.key;
        final ProductData product = entry.value;
        return InvoiceDetail(
          mItem: (initialLength + index + 1).toString(), // 自增的行号
          mProductCode: product.mCode,
          mProductName: product.mDesc1,
          mPrice: product.mLatCost ?? "0.00",
          mQty: "1.00",
          mAmount: product.mLatCost ?? "0.00",
          mDiscount: "0.00",
          mRemarks: "",
          tSupplierInvoiceInId: firstInvoiceId,
          mPoDetailId: "",
          mStockCode: defaultStock,
          mUnit: product.mUnit,
          mSupplierInvoiceInDetailId: "",
          mPoNo: "",
          mRevised: "",
          mProductContent: "",
        );
      }).toList(),
    );
    preCtl.updateTableHeight();
    preCtl.dataSource.updateDataSource();
    preCtl.updateTotalAmount();
    Get.back();
  }

  /// 加入套餐
  Future<void> joinSetMeal() async {
    final productCtl = Get.find<ProductEditController>();
    final oldSetMealCodes = productCtl.productSetMeal.map((e) => e.mBarcode).toSet().toList();
    final commonCodes = selectedItems.map((e) => e.mCode).toSet().intersection(oldSetMealCodes.toSet()).toList();
    final lastSelectProductCodes = List.from(selectedItems.map((e) => e.mCode));
    if (commonCodes.isNotEmpty) {
      await CustomAlert.iosAlert(
        message: "${LocaleKeys.theSelectedContentAlreadyExists.tr}:${commonCodes.join(",")}",
        showCancel: true,
        cancelText: LocaleKeys.ignore.tr,
        confirmText: LocaleKeys.skip.tr,
        onConfirm: () {
          lastSelectProductCodes.clear();
          lastSelectProductCodes.addAll(
            selectedItems.map((e) => e.mCode).toSet().difference(oldSetMealCodes.toSet()).toList(),
          );
        },
      );
    }
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
              ..assignAll(apiProductList.map((e) => ProductSetMeal.fromJson(e)).toList());
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
