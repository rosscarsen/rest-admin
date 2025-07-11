import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rest_admin/app/utils/logger.dart';

import '../../config.dart';
import '../../model/chart_model.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../translations/locale_keys.dart';
import '../../utils/custom_dialog.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();
  final ApiClient apiClient = ApiClient();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final isLoading = true.obs;
  Map<String, dynamic> search = {};
  RxBool hasPermission = true.obs;
  final apiResult = ApiResult().obs;
  @override
  void onInit() {
    getChartData();
    super.onInit();
  }

  Future<void> getChartData() async {
    isLoading(true);
    apiResult.value = ApiResult();
    try {
      final formatter = DateFormat('yyyy-MM-dd');
      search.putIfAbsent("startDate", () => formatter.format(DateTime.now().subtract(Duration(days: 7))));
      search.putIfAbsent("endDate", () => formatter.format(DateTime.now().subtract(Duration(days: 1))));

      final DioApiResult dioApiResult = await apiClient.post(Config.chartData, data: search);

      if (dioApiResult.success == false) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.hasPermission == false) {
        hasPermission.value = false;
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }

      final chartModel = chartModelFromJson(dioApiResult.data!);

      if (chartModel.status == 200) {
        apiResult.value = chartModel.apiResult ?? ApiResult();
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }
}
