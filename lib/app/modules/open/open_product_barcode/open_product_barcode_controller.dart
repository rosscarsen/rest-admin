import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/product/product_barcode_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import 'open_product_barcode_source.dart';

class OpenProductBarcodeController extends GetxController with LoadingStateMixin {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenProductBarcodeController get to => Get.find();
  List<ProductBarcodeData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenProductBarcodeDataSource dataSource;
  @override
  void onInit() {
    super.onInit();
    updateDataGridSource();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    searchController.dispose();
    super.onClose();
  }

  //重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages = 0;
    currentPage = 1;
    updateDataGridSource();
  }

  //更新数据源
  void updateDataGridSource() {
    getData().then((_) {
      dataSource = OpenProductBarcodeDataSource(this);
    });
  }

  ///获取产品列表
  Future<void> getData() async {
    isLoading = true;
    DataList.clear();
    try {
      Map<String, Object> search = {'page': currentPage};
      if (searchController.text.isNotEmpty) search['search'] = searchController.text;
      final DioApiResult dioApiResult = await apiClient.post(Config.openBarcode, data: search);
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
      final productBarcodeModel = productBarcodeModelFromJson(dioApiResult.data!);
      final BarcodeApiResult? apiResult = productBarcodeModel.apiResult;
      if (apiResult == null) {
        CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
        return;
      }

      DataList = apiResult.data ?? [];
      totalPages = apiResult.lastPage ?? 0;
      totalRecords = apiResult.total ?? 0;
    } finally {
      isLoading = false;
    }
  }
}
