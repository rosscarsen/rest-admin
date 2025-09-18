import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../model/customer/customer_contact.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import 'customer_edit_controller.dart';

class ContactAddOrEditView extends StatelessWidget {
  const ContactAddOrEditView({super.key, this.contactData});
  final CustomerContact? contactData;

  @override
  Widget build(BuildContext context) {
    final isNew = contactData == null;
    final row = contactData ?? CustomerContact();
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNew
              ? LocaleKeys.addParam.trArgs([LocaleKeys.contact.tr])
              : LocaleKeys.editParam.trArgs([LocaleKeys.contact.tr]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: FormHelper.buildGridRow(
              children: [
                //名称
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: "mName",
                    labelText: LocaleKeys.name.tr,
                    initialValue: row.mName,
                    validator: FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ),
                ),
                //电话
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(name: "mTel", labelText: LocaleKeys.tel.tr, initialValue: row.mTel),
                ),
                //手机
                FormHelper.buildGridCol(
                  child: FormHelper.phoneInput(
                    name: "mMobile_Phone",
                    labelText: LocaleKeys.mobile.tr,
                    initialValue: row.mMobilePhone,
                  ),
                ),
                //电邮
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: "mEmail",
                    labelText: LocaleKeys.email.tr,
                    initialValue: row.mEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      (val) {
                        if (val == null || val.isEmpty) return null;
                        return FormBuilderValidators.email(errorText: LocaleKeys.pleaseEnterAValidEmailAddress.tr)(val);
                      },
                    ]),
                  ),
                ),
                //传真
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(name: "mFax", labelText: LocaleKeys.fax.tr, initialValue: row.mFax),
                ),
                //部门
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: "mDepartment",
                    labelText: LocaleKeys.department.tr,
                    initialValue: row.mDepartment,
                  ),
                ),
                //地址
                FormHelper.buildGridCol(
                  sm: 12,
                  md: 12,
                  lg: 12,
                  xl: 12,
                  child: FormHelper.textInput(
                    name: "mAddress",
                    labelText: LocaleKeys.address.tr,
                    initialValue: row.mAddress,
                    maxLines: 2,
                  ),
                ),
                //备注
                FormHelper.buildGridCol(
                  sm: 12,
                  md: 12,
                  lg: 12,
                  xl: 12,
                  child: FormHelper.textInput(
                    name: "mRemarks",
                    labelText: LocaleKeys.remarks.tr,
                    initialValue: row.mRemarks,
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
                if (isNew) {
                  CustomerEditController.to.customerContactList.add(CustomerContact.fromJson(formData));
                } else {
                  row.updateFromSource(CustomerContact.fromJson(formData));
                }
                Get.closeAllDialogs();
                CustomerEditController.to.contactDataSource.updateDataSource();
              }
            }
          },
        ),
      ],
    );
  }
}
