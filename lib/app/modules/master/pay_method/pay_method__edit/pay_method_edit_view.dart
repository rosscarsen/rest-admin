import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import '../pay_method_table_fields.dart';
import 'pay_method_edit_controller.dart';

class PayMethodEditView extends GetView<PayMethodEditController> {
  const PayMethodEditView({super.key});
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
    final data = controller.data;
    final connectList = data?.connectList ?? {};
    final networkPayMethod = data?.networkPayMethod ?? [];

    return Skeletonizer(
      enabled: controller.isLoading,
      child: FormBuilder(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FormHelper.buildGridRow(
            children: [
              //支付方式
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: PayMethodTableFields.mPayType,
                  labelText: LocaleKeys.code.tr,
                  enabled: controller.id == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                ),
              ),
              //排序
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: PayMethodTableFields.mSort,
                  labelText: LocaleKeys.sort.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 0,
                ),
              ),
              //预支付
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: PayMethodTableFields.mPrePaid,
                  labelText: LocaleKeys.prePaid.tr,
                  initialValue: "",
                  items: [
                    DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //接口地址
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: PayMethodTableFields.mCom, labelText: LocaleKeys.interfaceAddress.tr),
              ),
              //连接列表
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: PayMethodTableFields.mCardType,
                  labelText: LocaleKeys.connect.tr,
                  initialValue: "",
                  items: connectList.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                ),
              ),
              //手动弹柜
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: PayMethodTableFields.mNoDrawer,
                  labelText: LocaleKeys.manualDrawer.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //网上支付方式
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: PayMethodTableFields.tPayTypeOnline,
                  labelText: LocaleKeys.networkPayMethod.tr,
                  initialValue: "",
                  items: [
                    DropdownMenuItem(value: "", child: Text("")),
                    ...networkPayMethod.map(
                      (e) => DropdownMenuItem(value: e.tPaytype, child: Text("${e.tSupplier} [${e.tPaytype}]")),
                    ),
                  ],
                ),
              ),
              //隐藏
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: PayMethodTableFields.mHide,
                  labelText: LocaleKeys.hide.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
