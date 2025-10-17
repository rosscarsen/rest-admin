import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/set_meal/set_meal_data.dart';
import '../../../model/set_meal/set_meal_page_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import 'open_set_meal_source.dart';

class OpenSetMealController extends GetxController with LoadingStateMixin {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenSetMealController get to => Get.find();

  List<SetMealData> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenSetMealSource dataSource;
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
      dataSource = OpenSetMealSource(this);
    });
  }

  ///获取列表
  Future<void> getData() async {
    isLoading = true;
    DataList.clear();
    try {
      Map<String, Object> search = {'page': currentPage};
      if (searchController.text.isNotEmpty) search['search'] = searchController.text;
      final DioApiResult dioApiResult = await apiClient.post(Config.openSetMeal, data: search);

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
      final SetMealPageModel setMealPageModel = setMealPageModelFromJson(dioApiResult.data!);
      if (setMealPageModel.status == 200) {
        final SetMealResult? apiResult = setMealPageModel.apiResult;
        DataList
          ..clear()
          ..addAll(apiResult?.data ?? []);
        totalPages = apiResult?.lastPage ?? 0;
        totalRecords = apiResult?.total ?? 0;
      }
    } finally {
      isLoading = false;
    }
  }
}
