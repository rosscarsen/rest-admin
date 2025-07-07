import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import 'open_products_data_source.dart';
import '../../../model/products_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/easy_loading.dart';

class OpenProductController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenProductController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<ProductData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenProductsDataSource dataSource;
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

  //重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
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
    isLoading(true);
    DataList.clear();
    try {
      Map<String, Object> search = {'page': currentPage.value};
      if (searchController.text.isNotEmpty) search['search'] = searchController.text;
      final DioApiResult dioApiResult = await apiClient.post(Config.openProduct, data: search);
      if (!dioApiResult.success) {
        showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (!dioApiResult.hasPermission) {
        showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data == null) {
        showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final productsModel = productsModelFromJson(dioApiResult.data!);
      if (productsModel.status == 200) {
        DataList = productsModel.apiResult?.productData ?? [];
        totalPages.value = (productsModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (productsModel.apiResult?.total ?? 0);
      } else {
        errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }
}
