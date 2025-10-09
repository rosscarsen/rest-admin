import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/product/products_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import 'open_products_data_source.dart';

class OpenProductController extends GetxController with LoadingStateMixin {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenProductController get to => Get.find();
  List<ProductData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenProductsDataSource dataSource;
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
    getProduct().then((_) {
      dataSource = OpenProductsDataSource(this);
    });
  }

  ///获取产品列表
  Future<void> getProduct() async {
    isLoading = true;
    DataList.clear();
    try {
      Map<String, Object> search = {'page': currentPage, "byCode": "asc"};
      if (searchController.text.isNotEmpty) search['search'] = searchController.text;
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
        totalPages = (productsModel.apiResult?.lastPage ?? 0);
        totalRecords = (productsModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading = false;
    }
  }
}
