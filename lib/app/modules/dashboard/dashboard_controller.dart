import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config.dart';
import '../../mixin/loading_state_mixin.dart';
import '../../model/chart_model.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../translations/locale_keys.dart';
import '../../utils/custom_dialog.dart';

class DashboardController extends GetxController with LoadingStateMixin {
  static DashboardController get to => Get.find();
  final ApiClient apiClient = ApiClient();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> search = {};
  final apiResult = ChartResult().obs;
  @override
  void onInit() {
    super.onInit();
    getChartData();
  }

  Future<void> getChartData() async {
    isLoading = true;
    apiResult.value = ChartResult();
    try {
      final formatter = DateFormat('yyyy-MM-dd');
      search.putIfAbsent("startDate", () => formatter.format(DateTime.now().subtract(Duration(days: 7))));
      search.putIfAbsent("endDate", () => formatter.format(DateTime.now().subtract(Duration(days: 1))));

      final DioApiResult dioApiResult = await apiClient.get(Config.chartData, data: search);

      if (dioApiResult.success == false) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.hasPermission == false) {
        hasPermission = false;
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }

      final chartModel = chartModelFromJson(dioApiResult.data!);

      if (chartModel.status == 200) {
        apiResult.value = chartModel.apiResult ?? ChartResult();
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading = false;
    }
  }
}
