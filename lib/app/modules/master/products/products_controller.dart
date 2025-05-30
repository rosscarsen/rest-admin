import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../dataSource/masterSource/product/products_data_source.dart';
import '../../../excel/custom_execl.dart';
import '../../../model/product_export_model.dart';
import '../../../model/products_model.dart';
import '../../../service/api_client.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/easy_loding.dart';
import '../../../utils/functions.dart';

class ProductsController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static ProductsController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  List<ProductData> dataList = [];
  final ApiClient apiClient = ApiClient();
  late ProductsDataSource dataSource;
  Map<String, dynamic> advancedSearch = {};
  Map<String, dynamic> sort = {"byCode": "asc"};
  RxBool hasPermission = true.obs;
  @override
  void onInit() {
    updateDataGridSource();
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    searchController.dispose();
    super.onClose();
  }

  //排序搜索
  void sortButton({required bool isByCode}) {
    FocusManager.instance.primaryFocus?.unfocus();

    String key = isByCode ? "byCode" : "bySort";
    String oppositeKey = isByCode ? "bySort" : "byCode";

    if (sort.containsKey(oppositeKey)) {
      sort.remove(oppositeKey);
    }

    if (sort.containsKey(key)) {
      sort.update(key, (val) => val == "asc" ? "desc" : "asc");
    } else {
      sort.addAll({key: "asc"});
    }
    reloadData();
  }

  //重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
    updateDataGridSource();
  }

  //更新数据源
  void updateDataGridSource() {
    dataGridController.selectedRows = [];
    getProduct().then((_) {
      dataSource = ProductsDataSource(this);
    });
  }

  ///获取产品列表
  Future<void> getProduct() async {
    isLoading(true);
    dataList.clear();
    try {
      Map<String, dynamic> search = {'page': currentPage.value};
      search.addAll(sort);
      if (advancedSearch.isNotEmpty) {
        search.addAll(advancedSearch);
      }
      if (searchController.text.isNotEmpty) {
        search.addAll({"search": searchController.text});
      }

      final String? result = await apiClient.post(Config.product, data: search);

      if (result?.isEmpty ?? true) return;

      if (result == Config.noPermission) {
        hasPermission.value = false;
        return;
      }
      hasPermission.value = true;

      final productsModel = productsModelFromJson(result!);
      if (productsModel.status == 200) {
        dataList = productsModel.productsInfo?.productData ?? [];
        totalPages.value = (productsModel.productsInfo?.lastPage ?? 0);
      } else {
        errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }

  //导出
  void exportSetMeal(ProductData row) {}
  //复制
  void copy(ProductData row) {}
  //编辑
  void edit(ProductData row) {
    row.mCategory1 = "修改";
    dataSource.updateDataSource();
  }

  //删除单行数据
  void deleteRow(ProductData row) async {
    await deleteRemoteProduct([row.tProductId]);
  }

  //批量删除食品
  void deleteSelectedRows() async {
    final selectedRows = dataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      showToast(LocaleKeys.pleaseSelectOneDataOrMoreToDelete.tr);
      return;
    }
    final selectedIDS = selectedRows.map((dataGridRow) {
      final product = dataGridRow.getCells().firstWhereOrNull((cell) => cell.columnName == 'ID')?.value;
      return product;
    }).toList();
    await deleteRemoteProduct(selectedIDS);
  }

  // 批量删除套餐
  void deleteeSelectedSetMeal() {
    final selectedRows = dataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      showToast(LocaleKeys.pleaseSelectOneDataOrMoreToDelete.tr);
      return;
    }
    final selectedIDS = selectedRows.map((dataGridRow) {
      final product = dataGridRow.getCells().firstWhereOrNull((cell) => cell.columnName == 'ID')?.value;
      return product;
    }).toList();
    CustomAlert.iosAlert(
      showCancel: true,
      LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          showLoding(LocaleKeys.deleting.tr);
          final String? result = await apiClient.post(
            Config.batchDeleteSetMeal,
            data: {"productIDs": jsonEncode(selectedIDS)},
          );

          if (result?.isEmpty ?? true) return;
          if (result == Config.noPermission) {
            showToast(LocaleKeys.noPermission.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(result!) as Map<String, dynamic>;

          switch (data['status']) {
            case 200:
              successMessages(LocaleKeys.deleteSuccess.tr);
              reloadData();
              break;
            case 201:
              errorMessages(LocaleKeys.deleteFailed.tr);
            default:
              errorMessages(LocaleKeys.unknownError.tr);
          }
        } catch (e) {
          errorMessages(LocaleKeys.deleteFailed.tr);
        } finally {
          dismissLoding();
        }
      },
    );
  }

  //远程删除
  Future<void> deleteRemoteProduct(List<dynamic> selectedIDS) async {
    CustomAlert.iosAlert(
      showCancel: true,
      LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          showLoding(LocaleKeys.deleting.tr);
          final String? result = await apiClient.post(
            Config.batchDeleteProduct,
            data: {"ids": jsonEncode(selectedIDS)},
          );

          if (result?.isEmpty ?? true) return;
          if (result == Config.noPermission) {
            showToast(LocaleKeys.noPermission.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(result!) as Map<String, dynamic>;
          // logger.d(data);
          switch (data['status']) {
            case 200:
              successMessages(LocaleKeys.deleteSuccess.tr);
              reloadData();
              break;
            case 201:
              errorMessages(LocaleKeys.ftpConnectFailed.tr);
              break;
            case 202:
              errorMessages(LocaleKeys.exitsTxCannotDelete.tr.trArgs([data['msg']]));
            default:
              errorMessages(LocaleKeys.unknownError.tr);
          }
        } catch (e) {
          errorMessages(LocaleKeys.deleteFailed.tr);
        } finally {
          dismissLoding();
        }
      },
    );
  }

  //图片上传
  void uploadImage(ProductData row, BuildContext context) async {
    XFile? ret = await Functions.imagePicker(context);
    if (ret == null) return;
    try {
      showLoding(LocaleKeys.uploading.tr);
      final String? result = await apiClient.uploadImage(
        image: ret,
        uploadUrl: Config.uploadProductImage,
        code: row.mCode,
      );
      if (result?.isEmpty ?? true) return;
      if (result == Config.noPermission) {
        showToast(LocaleKeys.noPermission.tr);
        return;
      }
      final Map<String, dynamic> data = jsonDecode(result!) as Map<String, dynamic>;
      switch (data['status']) {
        case 200:
          String? imagesPath = data["data"];
          successMessages(LocaleKeys.uploadSuccess.tr);
          row.imagesPath = "$imagesPath?timestamp=${DateTime.now().millisecondsSinceEpoch}";
          dataSource.updateDataSource();
          break;
        case 201:
          errorMessages(LocaleKeys.ftpInfoNotIsSet.tr);
          break;
        case 202:
          errorMessages(LocaleKeys.ftpConnectFailed.tr);
          break;
        case 203:
          errorMessages(LocaleKeys.ftpLoginFailed.tr);
          break;
        case 204:
          errorMessages(LocaleKeys.fileNotFound.tr);
          break;
        case 205:
          errorMessages(LocaleKeys.uploadFailed.tr);
          break;
        default:
          errorMessages(LocaleKeys.unknownError.tr);
      }
    } finally {
      dismissLoding();
    }
  }

  //导出产品
  Future<void> exportProduct() async {
    showLoding(LocaleKeys.gettingData.tr);
    Map<String, dynamic> query = {};
    query.addAll(sort);
    if (advancedSearch.isNotEmpty) {
      query.addAll(advancedSearch);
    }
    if (searchController.text.isNotEmpty) {
      query.addAll({"search": searchController.text});
    }

    final String? jsonString = await apiClient.post(Config.exportProductExcel, data: query);

    if (jsonString?.isEmpty ?? true) {
      showToast(LocaleKeys.noRecordFound.tr);
      return;
    }
    if (jsonString == Config.noPermission) {
      showToast(LocaleKeys.noPermission.tr);
      return;
    }
    dismissLoding();
    final productExportModel = productExportModelFromJson(jsonString!);
    if (productExportModel.result?.isNotEmpty ?? false) {
      await CustomExecl.exportProduct(productExportModel.result!);
    } else {
      showToast(LocaleKeys.noRecordFound.tr);
    }
  }
}
