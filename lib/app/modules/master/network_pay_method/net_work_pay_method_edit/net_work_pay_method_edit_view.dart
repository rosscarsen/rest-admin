import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import '../network_pay_method_table_fields.dart';
import 'net_work_pay_method_edit_controller.dart';

class NetWorkPayMethodEditView extends GetView<NetWorkPayMethodEditController> {
  const NetWorkPayMethodEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          centerTitle: true,
          actions: controller.isLoading
              ? null
              : [
                  Tooltip(
                    message: LocaleKeys.refresh.tr,
                    child: IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.refreshData()),
                  ),
                ],
        ),

        body: controller.hasPermission ? _buildMain() : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: controller.isLoading || !controller.hasPermission ? null : () => controller.save(),
          ),
        ],
      ),
    );
  }

  /// 构建表单
  Widget _buildMain() {
    final List<String> allSupplier = controller.data?.allSupplier?.map((e) => e.tSupplier ?? "").toSet().toList() ?? [];
    final List<String> allPayMethod = controller.data?.allPayMethod?.toSet().toList() ?? [];
    return Skeletonizer(
      enabled: controller.isLoading,
      child: FormBuilder(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FocusTraversalGroup(
            child: FormHelper.buildGridRow(
              children: [
                //供应商
                FormHelper.buildGridCol(
                  child: FormHelper.autoCompleteInput(
                    name: NetworkPayMethodTableFields.tSupplier,
                    labelText: LocaleKeys.supplier.tr,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                    ]),
                    items: allSupplier,
                  ),
                ),
                //支付方式
                FormHelper.buildGridCol(
                  child: FormHelper.autoCompleteInput(
                    name: NetworkPayMethodTableFields.tPayType,
                    labelText: LocaleKeys.paymentMethod.tr,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                    ]),
                    items: allPayMethod,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
