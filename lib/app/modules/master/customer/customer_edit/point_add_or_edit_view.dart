import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../model/customer/point_list.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import 'customer_edit_controller.dart';

class PointAddOrEditView extends StatelessWidget {
  const PointAddOrEditView({super.key, required this.pointData, required this.isAdd});
  final PointData pointData;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    final oldRow = pointData.copyWith();
    final newRow = pointData.copyWith();

    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAdd
              ? LocaleKeys.addParam.trArgs([LocaleKeys.point.tr])
              : LocaleKeys.editParam.trArgs([LocaleKeys.point.tr]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: FormHelper.buildGridRow(
              children: [
                //发票编号
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: "mRef_No",
                    enabled: isAdd,
                    labelText: LocaleKeys.invoiceNo.tr,
                    initialValue: oldRow.mRefNo,
                    validator: FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ),
                ),
                //日期
                FormHelper.buildGridCol(
                  child: FormHelper.dateInput(
                    name: "mDeposit_Date",
                    labelText: LocaleKeys.date.tr,
                    initialValue: oldRow.mDepositDate,
                  ),
                ),
                //积分
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: "mAmount",
                    labelText: LocaleKeys.point.tr,
                    initialValue: oldRow.mAmount,
                    keyboardType: TextInputType.number,
                  ),
                ),
                //备注
                FormHelper.buildGridCol(
                  sm: 12,
                  md: 12,
                  lg: 12,
                  xl: 12,
                  child: FormHelper.textInput(
                    name: "mRemark",
                    labelText: LocaleKeys.remarks.tr,
                    initialValue: oldRow.mRemark,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        FormHelper.saveButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              final formData = formKey.currentState?.value;
              if (formData != null) {
                newRow.updateFromSource(PointData.fromJson(formData));
                Get.closeDialog();
                if (!isAdd) {
                  final isSame = Functions.compareMap(oldRow.toJson(), newRow.toJson());
                  if (isSame) {
                    return;
                  }
                }
                //网络请求
                logger.f(newRow.toJson());
                CustomerEditController.to.saveCustomerPoint(row: newRow, isAdd: isAdd);
              }
            }
          },
        ),
      ],
    );
  }
}
