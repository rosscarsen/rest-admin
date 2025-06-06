import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../dataSource/openSource/open_products_data_source.dart';
import '../../../model/products_model.dart';
import '../../../service/api_client.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/easy_loading.dart';

class OpenProductController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenProductController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
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
      final String? result = await apiClient.post(Config.openProduct, data: search);
      if (result?.isEmpty ?? true) return;
      if (result == Config.noPermission) {
        showToast(LocaleKeys.noPermission.tr);
        return;
      }
      final productsModel = productsModelFromJson(result!);
      if (productsModel.status == 200) {
        DataList = productsModel.productsInfo?.productData ?? [];
        totalPages.value = (productsModel.productsInfo?.lastPage ?? 0);
      } else {
        errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }
}
