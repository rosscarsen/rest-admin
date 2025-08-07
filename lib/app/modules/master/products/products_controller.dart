import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../model/products_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/file_storage.dart';
import '../../../utils/functions.dart';
import '../../../utils/logger.dart';
import 'products_data_source.dart';

class ProductsController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static ProductsController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
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
      Map<String, dynamic> search = {
        'page': currentPage.value,
        'hasImage': true,
        ...sort,
        if (advancedSearch.isNotEmpty) ...advancedSearch,
        if (searchController.text.isNotEmpty) 'search': searchController.text,
      };

      final DioApiResult dioApiResult = await apiClient.post(Config.product, data: search);

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      hasPermission.value = true;
      //logger.f(dioApiResult.data);
      final productsModel = productsModelFromJson(dioApiResult.data.toString());
      if (productsModel.status == 200) {
        dataList = productsModel.apiResult?.productData ?? [];
        totalPages.value = (productsModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (productsModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
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
  void edit({ProductData? row}) {
    Get.toNamed(Routes.PRODUCT_EDIT, parameters: row != null ? {"id": row.tProductId?.toString() ?? ""} : null);
    /* row.mCategory1 = "修改";
    dataSource.updateDataSource(); */
  }

  //删除单行数据
  void deleteRow(ProductData row) async {
    await deleteRemoteProduct([row.tProductId]);
  }

  //批量删除食品
  void deleteSelectedRows() async {
    final selectedRows = dataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      CustomDialog.showToast(LocaleKeys.pleaseSelectOneDataOrMoreToDelete.tr);
      return;
    }
    final selectedIDS = selectedRows.map((dataGridRow) {
      final product = dataGridRow.getCells().firstWhereOrNull((cell) => cell.columnName == 'ID')?.value;
      return product;
    }).toList();
    await deleteRemoteProduct(selectedIDS);
  }

  // 批量删除套餐
  void deleteSelectedSetMeal() {
    final selectedRows = dataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      CustomDialog.showToast(LocaleKeys.pleaseSelectOneDataOrMoreToDelete.tr);
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
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.post(
            Config.batchDeleteSetMeal,
            data: {"productIDs": jsonEncode(selectedIDS)},
          );

          if (!dioApiResult.success) {
            CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;

          switch (data['status']) {
            case 200:
              CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
              reloadData();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
            default:
              CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
          }
        } catch (e) {
          CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
        } finally {
          CustomDialog.dismissDialog();
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
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.post(
            Config.batchDeleteProduct,
            data: {"ids": jsonEncode(selectedIDS)},
          );

          if (!dioApiResult.success) {
            CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;

          switch (data['status']) {
            case 200:
              CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
              dataList.removeWhere((element) => selectedIDS.contains(element.tProductId));
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.ftpConnectFailed.tr);
              break;
            case 202:
              logger.f(data['msg']);
              CustomAlert.iosAlert(LocaleKeys.exitsTxCannotDelete.tr.trArgs([data['msg']]));
            default:
              CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
          }
        } catch (e) {
          CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
        } finally {
          CustomDialog.dismissDialog();
        }
      },
    );
  }

  //图片上传
  Future<void> uploadImage(ProductData row, BuildContext context) async {
    XFile? ret = await Functions.imagePicker(context);
    if (ret == null) return;
    try {
      CustomDialog.showLoading(LocaleKeys.uploading.tr);
      final DioApiResult dioApiResult = await apiClient.uploadImage(
        image: ret,
        uploadUrl: Config.uploadProductImage,
        code: row.mCode,
      );

      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (dioApiResult.data == null) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final Map<String, dynamic> data = json.decode(dioApiResult.data) as Map<String, dynamic>;
      switch (data['status']) {
        case 200:
          String? imagesPath = data["apiResult"];
          CustomDialog.successMessages(LocaleKeys.uploadSuccess.tr);
          row.imagesPath = "$imagesPath?timestamp=${DateTime.now().millisecondsSinceEpoch}";
          dataSource.updateDataSource();
          break;
        case 201:
          CustomDialog.errorMessages(LocaleKeys.ftpInfoNotIsSet.tr);
          break;
        case 202:
          CustomDialog.errorMessages(LocaleKeys.ftpConnectFailed.tr);
          break;
        case 203:
          CustomDialog.errorMessages(LocaleKeys.ftpLoginFailed.tr);
          break;
        case 204:
          CustomDialog.errorMessages(LocaleKeys.fileNotFound.tr);
          break;
        case 205:
          CustomDialog.errorMessages(LocaleKeys.uploadFailed.tr);
          break;
        default:
          CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
      }
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  //导出产品
  Future<void> exportProduct() async {
    CustomDialog.showLoading(LocaleKeys.generating.trArgs(["excel"]));
    Map<String, dynamic> query = {
      "lang": (Get.locale?.toString() ?? "zh_HK").toLowerCase(),
      ...sort,
      if (advancedSearch.isNotEmpty) ...advancedSearch,
      if (searchController.text.isNotEmpty) 'search': searchController.text,
    };

    try {
      final DioApiResult dioApiResult = await apiClient.downLoadExcel(
        Config.exportProductExcel,
        queryParameters: query,
      );
      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data is Uint8List) {
        FileStorage.saveFileToDownloads(
          bytes: dioApiResult.data as Uint8List,
          fileName: dioApiResult.fileName!,
          fileType: DownloadFileType.Excel,
        );
      }
    } catch (e) {
      logger.i(e);
      CustomDialog.errorMessages(LocaleKeys.generateFileFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  // 导入产品
  Future<void> importProduct({required File file, required Map<String, dynamic> query}) async {
    CustomDialog.showLoading(LocaleKeys.importing.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.uploadFile(
        file: file,
        uploadUrl: Config.importProductExcel,
        extraData: query,
      );

      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.importFailed.tr);
        return;
      }
      reloadData();
      CustomDialog.successMessages(LocaleKeys.importFileSuccess.tr);
    } catch (e) {
      CustomDialog.showToast(LocaleKeys.importFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }
}
