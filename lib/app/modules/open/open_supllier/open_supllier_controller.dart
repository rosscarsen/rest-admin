import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../dataSource/openSource/open_supplier_data_source.dart';
import '../../../model/supplier_model.dart';
import '../../../service/api_client.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/easy_loding.dart';

class OpenSupllierController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenSupllierController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  List<SupplierData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenSupplierDataSource dataSource;
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
    getData().then((_) {
      dataSource = OpenSupplierDataSource(this);
    });
  }

  ///获取产品列表
  Future<void> getData() async {
    isLoading(true);
    DataList.clear();
    try {
      Map<String, Object> search = {'page': currentPage.value};
      if (searchController.text.isNotEmpty) search['search'] = searchController.text;
      final String? jsonString = await apiClient.post(Config.openSupplier, data: search);
      if (jsonString?.isEmpty ?? true) {
        return;
      }
      if (jsonString == Config.noPermission) {
        showToast(LocaleKeys.noPermission.tr);
        return;
      }
      final supplierModel = supplierModelFromJson(jsonString!);
      DataList = supplierModel.supplierData ?? [];
      totalPages.value = supplierModel.lastPage ?? 0;
    } finally {
      isLoading(false);
    }
  }
}
