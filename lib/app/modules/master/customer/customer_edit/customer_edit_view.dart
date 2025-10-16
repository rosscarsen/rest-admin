import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/customer/customer_edit_model.dart';
import '../../../../model/customer/point_list.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/progress_hub.dart';
import '../../../../widgets/custom_cell.dart';
import '../../../../theme/data_grid_theme.dart';
import '../../../../widgets/data_pager.dart';
import '../../../../widgets/no_record.dart';
import '../customer_fields.dart';
import 'customer_edit_controller.dart';

class CustomerEditView extends GetView<CustomerEditController> {
  const CustomerEditView({super.key});
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
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => controller.updateDataGridSource(),
                    ),
                  ),
                ],
          bottom: controller.hasPermission
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: TabBar(
                      isScrollable: true,
                      controller: controller.tabController,
                      tabs: [
                        Tab(text: LocaleKeys.basicInfo.tr),
                        Tab(text: LocaleKeys.contact.tr),
                        if (controller.id != null) Tab(text: LocaleKeys.point.tr),
                      ],
                      labelColor: Colors.blueAccent,
                      indicatorColor: Colors.blueAccent,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey.shade600,
                      overlayColor: WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
                      tabAlignment: TabAlignment.start,
                    ),
                  ),
                )
              : null,
        ),

        body: controller.hasPermission ? buildMain(context) : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: controller.isLoading || !controller.hasPermission ? null : () => controller.save(),
          ),
        ],
      ),
    );
  }

  Widget buildMain(BuildContext context) {
    return IndexedStack(
      index: controller.tabIndex.value.clamp(0, 2),
      children: [_buildBasicInfo(context), _buildContact(context), if (controller.id != null) _buildPoints(context)],
    );
  }

  /// 基本信息
  Widget _buildBasicInfo(BuildContext context) {
    bool visibility = controller.id != null;
    return Skeletonizer(
      enabled: controller.isLoading,
      child: FormBuilder(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHelper.buildGridRow(
                children: [
                  //类型
                  FormHelper.buildGridCol(
                    child: FormHelper.autoCompleteInput(
                      name: CustomerFields.mCustomer_Type,
                      labelText: LocaleKeys.type.tr,
                      items: controller.customerTypeList,
                    ),
                  ),
                  //编号
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: CustomerFields.mCode,
                      labelText: LocaleKeys.code.tr,
                      enabled: controller.id == null,
                      validator: FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                    ),
                  ),
                  //简称
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(name: CustomerFields.mSimpleName, labelText: LocaleKeys.simpleName.tr),
                  ),
                  //卡号
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(name: CustomerFields.mCardNo, labelText: LocaleKeys.cardNo.tr),
                  ),
                  //手机
                  FormHelper.buildGridCol(
                    child: FormHelper.phoneInput(
                      name: CustomerFields.mPhone_No,
                      labelText: LocaleKeys.mobile.tr,
                      isRequired: true,
                    ),
                  ),
                  //非启用状态
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: CustomerFields.mNon_Active,
                      labelText: LocaleKeys.nonEnable.tr,
                      initialValue: "0",
                      items: [
                        DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                        DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                      ],
                    ),
                  ),
                  //全称
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(name: CustomerFields.mFullName, labelText: LocaleKeys.fullName.tr),
                  ),
                  //密码
                  FormHelper.buildGridCol(
                    child: StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return FormBuilderTextField(
                          readOnly: visibility,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.password.tr,
                            suffixIcon: controller.id == null
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        visibility = false;
                                        controller.formKey.currentState?.fields[CustomerFields.mPassword]?.didChange(
                                          "",
                                        );
                                      });
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                          ),
                          name: CustomerFields.mPassword,
                          obscureText: visibility,
                        );
                      },
                    ),
                  ),
                  //创建日期
                  FormHelper.buildGridCol(
                    child: FormHelper.dateInput(
                      initialValue: DateTime.now(),
                      name: CustomerFields.mCreateDate,
                      labelText: LocaleKeys.createDate.tr,
                      enabled: false,
                    ),
                  ),
                  //地址
                  FormHelper.buildGridCol(
                    sm: 12,
                    md: 12,
                    lg: 12,
                    xl: 12,
                    child: FormHelper.textInput(
                      name: CustomerFields.mAddress,
                      labelText: LocaleKeys.address.tr,
                      maxLines: 2,
                    ),
                  ),
                  // 过期日
                  FormHelper.buildGridCol(
                    child: FormHelper.dateInput(
                      name: CustomerFields.mExpiry_Date,
                      labelText: LocaleKeys.expiredDate.tr,
                    ),
                  ),
                  //传真
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(name: CustomerFields.mFax_No, labelText: LocaleKeys.fax.tr),
                  ),
                  //电邮
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: CustomerFields.mEmail,
                      labelText: LocaleKeys.email.tr,
                      validator: FormBuilderValidators.compose([
                        (val) {
                          if (val == null || val.isEmpty) return null;
                          return FormBuilderValidators.email(errorText: LocaleKeys.pleaseEnterAValidEmailAddress.tr)(
                            val,
                          );
                        },
                      ]),
                    ),
                  ),
                ],
              ),
              Divider(indent: 4, endIndent: 4),
              FormHelper.buildGridRow(
                children: [
                  //激活
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: CustomerFields.mInfoNA,
                      labelText: LocaleKeys.active.tr,
                      initialValue: "0",
                      items: [
                        DropdownMenuItem(value: "0", child: Text(LocaleKeys.yes.tr)),
                        DropdownMenuItem(value: "1", child: Text(LocaleKeys.no.tr)),
                      ],
                    ),
                  ),
                  //折扣(0-100)
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: CustomerFields.mST_Discount,
                      labelText: LocaleKeys.discount.tr,
                      keyboardType: TextInputType.number,
                      maxDecimalDigits: 2,
                    ),
                  ),
                  //貨幣
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: CustomerFields.mST_Currency,
                      labelText: LocaleKeys.currency.tr,
                      initialValue: "HKD",
                      items: [
                        DropdownMenuItem(value: "HKD", child: Text("HKD")),
                        ...controller.currencyList.where((e) => (e.mCode?.toUpperCase() ?? "") != "HKD").map((e) {
                          return DropdownMenuItem(value: e.mCode, child: Text(e.mCode ?? ""));
                        }),
                      ],
                    ),
                  ),
                  //性別
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: CustomerFields.mSex,
                      labelText: LocaleKeys.gender.tr,
                      initialValue: "0",
                      items: [
                        DropdownMenuItem(value: "0", child: Text(LocaleKeys.male.tr)),
                        DropdownMenuItem(value: "1", child: Text(LocaleKeys.female.tr)),
                      ],
                    ),
                  ),
                  //積分
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: CustomerFields.mDeposit,
                      labelText: LocaleKeys.point.tr,
                      enabled: false,
                    ),
                  ),
                  //支付條款
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      initialValue: "",
                      name: CustomerFields.mST_Payment_Term,
                      labelText: LocaleKeys.paymentTerm.tr,
                      items: [DropdownMenuItem(value: "", child: Text(""))],
                    ),
                  ),
                  //婚姻狀況
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      initialValue: "0",
                      name: CustomerFields.mMarried,
                      labelText: LocaleKeys.maritalStatus.tr,
                      items: [
                        DropdownMenuItem(value: "0", child: Text(LocaleKeys.unmarried.tr)),
                        DropdownMenuItem(value: "1", child: Text(LocaleKeys.married.tr)),
                      ],
                    ),
                  ),
                  // 价格条款
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      initialValue: "",
                      name: CustomerFields.mST_Price_Term,
                      labelText: LocaleKeys.priceTerm.tr,
                    ),
                  ),
                  //信用额
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: CustomerFields.mST_Credit_Limit,
                      labelText: LocaleKeys.creditLimit.tr,
                      keyboardType: TextInputType.number,
                      maxDecimalDigits: 0,
                    ),
                  ),
                  // 生日
                  FormHelper.buildGridCol(
                    child: FormHelper.dateInput(
                      name: CustomerFields.mBirthday_Year,
                      labelText: LocaleKeys.birthday.tr,
                      inputType: DateInputType.date,
                    ),
                  ),
                  //支付方式
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: CustomerFields.mST_Payment_Method,
                      labelText: LocaleKeys.paymentMethod.tr,
                      initialValue: "0",
                      items: [
                        DropdownMenuItem(value: "0", child: Text(LocaleKeys.actualDay.tr)),
                        DropdownMenuItem(value: "1", child: Text(LocaleKeys.monthly.tr)),
                      ],
                    ),
                  ),
                  // 支付日数
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: CustomerFields.mST_Payment_Days,
                      labelText: LocaleKeys.paymentDays.tr,
                      keyboardType: TextInputType.number,
                      maxDecimalDigits: 0,
                    ),
                  ),
                ],
              ),
              Divider(indent: 4, endIndent: 4),
              FormHelper.buildGridRow(
                children: [
                  // 折扣
                  FormHelper.buildGridCol(
                    child: FormHelper.radioGroup(
                      name: CustomerFields.mSimple_Discount,
                      labelText: LocaleKeys.discount.tr,
                      decoration: InputDecoration(
                        label: Text(LocaleKeys.discount.tr),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      initialValue: "0",
                      options: [
                        FormBuilderFieldOption(value: "0", child: Text(LocaleKeys.no.tr)),
                        FormBuilderFieldOption(value: "1", child: Text(LocaleKeys.yes.tr)),
                      ],
                    ),
                  ),
                ],
              ),
              // 折扣 table
              Scrollbar(
                controller: controller.scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  scrollDirection: Axis.horizontal,
                  child: GetBuilder<CustomerEditController>(
                    init: CustomerEditController(),
                    initState: (_) {},
                    id: "customerDiscountList",
                    builder: (controller) {
                      return DataTable(
                        border: TableBorder.all(
                          color: const Color.fromARGB(255, 220, 220, 221),
                          width: 1.0,
                          style: BorderStyle.solid,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        columns: [
                          DataColumn(label: Text(LocaleKeys.category.tr)),
                          DataColumn(label: Text(LocaleKeys.discount.tr)),
                          DataColumn(label: Text(LocaleKeys.expiredDate.tr)),
                          DataColumn(label: Text(LocaleKeys.nonEnable.tr)),
                          DataColumn(
                            label: Row(
                              spacing: 8.0,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(LocaleKeys.operation.tr),
                                IconButton(
                                  tooltip: LocaleKeys.add.tr,
                                  icon: Icon(Icons.add, color: AppColors.addColor),
                                  onPressed: () {
                                    _buildCustomerDiscount(context, null);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                        rows: controller.customerDiscountList
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(e.mCategory ?? "")),
                                  DataCell(Text(e.mDiscount ?? "")),
                                  DataCell(Text(e.mExpiryDate ?? "")),
                                  DataCell(Text((e.mNonActive ?? "") == "0" ? LocaleKeys.no.tr : LocaleKeys.yes.tr)),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          tooltip: LocaleKeys.edit.tr,
                                          icon: Icon(Icons.edit, color: AppColors.editColor),
                                          onPressed: () {
                                            _buildCustomerDiscount(context, e);
                                          },
                                        ),
                                        IconButton(
                                          tooltip: LocaleKeys.delete.tr,
                                          icon: Icon(Icons.delete, color: AppColors.deleteColor),
                                          onPressed: () {
                                            controller.deleteCustomerDiscount(row: e);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ),

              FormHelper.buildGridRow(
                children: [
                  FormHelper.buildGridCol(
                    sm: 6,
                    md: 6,
                    lg: 6,
                    xl: 6,
                    child: FormHelper.textInput(
                      name: CustomerFields.mCustomer_Note,
                      labelText: "${LocaleKeys.remarks.tr}1",
                      maxLines: 2,
                    ),
                  ),
                  FormHelper.buildGridCol(
                    sm: 6,
                    md: 6,
                    lg: 6,
                    xl: 6,
                    child: FormHelper.textInput(
                      name: CustomerFields.mRemarks,
                      labelText: "${LocaleKeys.remarks.tr}2",
                      maxLines: 2,
                    ),
                  ),
                ],
              ).paddingOnly(top: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  /// 编辑或新增客户折扣
  Future _buildCustomerDiscount(BuildContext context, CustomerDiscount? row) {
    final bool isNew = row == null;
    row ??= CustomerDiscount();
    return Get.dialog(
      AlertDialog(
        title: Text(isNew ? LocaleKeys.add.tr : LocaleKeys.edit.tr),
        content: SingleChildScrollView(
          child: Column(
            spacing: 8.0,
            children: [
              //类目
              FormHelper.textInput(
                initialValue: row.mCategory ?? "",
                name: "mCategory",
                labelText: LocaleKeys.category.tr,
                onChanged: (v) => row?.mCategory = v,
              ),
              //折扣
              FormHelper.textInput(
                initialValue: row.mDiscount ?? "",
                name: "mDiscount",
                labelText: LocaleKeys.discount.tr,
                keyboardType: TextInputType.number,
                maxDecimalDigits: 2,
                onChanged: (v) => row?.mDiscount = v,
              ),
              //过期日
              FormHelper.dateInput(
                initialValue: row.mExpiryDate ?? "",
                name: "mExpiryDate",
                labelText: LocaleKeys.expiredDate.tr,
                onChanged: (v) => row?.mExpiryDate = v,
              ),
              //非启用
              FormHelper.selectInput(
                initialValue: row.mNonActive ?? "0",
                name: "mNonActive",
                labelText: LocaleKeys.nonEnable.tr,
                items: [
                  DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                  DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                ],
                onChanged: (v) => row?.mNonActive = v,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(onPressed: () => Get.closeDialog(), child: Text(LocaleKeys.cancel.tr)),
          ElevatedButton(
            onPressed: () async {
              Get.closeDialog();
              controller.addOrEditCustomerDiscount(row: row, isAdd: isNew);
            },
            child: Text(LocaleKeys.save.tr),
          ),
        ],
      ),
    );
  }

  /// 联络人
  Widget _buildContact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: () => controller.editOrAddContact(), child: Text(LocaleKeys.add.tr)),
          ),
          Expanded(
            child: ProgressHUD(
              child: controller.isLoading
                  ? null
                  : DataGridTheme(
                      child: SfDataGrid(
                        isScrollbarAlwaysShown: true,
                        footerFrozenColumnsCount: 1,
                        frozenColumnsCount: 0,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                        columnWidthMode: ColumnWidthMode.auto,
                        showCheckboxColumn: false,
                        selectionMode: SelectionMode.none,
                        source: controller.contactDataSource,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'mName',
                            label: CustomCell(data: LocaleKeys.name.tr),
                          ),
                          GridColumn(
                            columnName: 'mEmail',
                            label: CustomCell(data: LocaleKeys.email.tr),
                            columnWidthMode: ColumnWidthMode.fill,
                            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                          ),
                          GridColumn(
                            columnName: 'mMobilePhone',
                            label: CustomCell(data: LocaleKeys.mobile.tr),
                            columnWidthMode: ColumnWidthMode.fill,
                            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                          ),
                          GridColumn(
                            columnName: 'mFax',
                            label: CustomCell(data: LocaleKeys.fax.tr),
                          ),
                          GridColumn(
                            columnName: 'mDepartment',
                            label: CustomCell(data: LocaleKeys.department.tr),
                          ),
                          GridColumn(
                            allowSorting: false,
                            columnName: 'actions',
                            width: 80,
                            label: CustomCell(data: LocaleKeys.operation.tr),
                          ),
                        ],
                        placeholder: NoRecordPermission(
                          msg: controller.hasPermission ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// 积分
  Widget _buildPoints(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                child: GetBuilder<CustomerEditController>(
                  init: CustomerEditController(),
                  id: "amount",
                  initState: (_) {},
                  builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${LocaleKeys.invoiceAmount.tr} : ${controller.getInvoiceAmount}"),
                        Text("${LocaleKeys.point.tr} : ${controller.getCustomerPoint ?? ""}"),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.editOrAddPoint(row: PointData(tCustomerId: controller.id), isAdd: true),
                child: Text(LocaleKeys.add.tr),
              ),
            ],
          ),
          Expanded(
            child: ProgressHUD(
              child: controller.isLoading
                  ? null
                  : DataGridTheme(
                      child: SfDataGrid(
                        isScrollbarAlwaysShown: true,
                        footerFrozenColumnsCount: 1,
                        frozenColumnsCount: 0,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                        columnWidthMode: ColumnWidthMode.fill,
                        showCheckboxColumn: false,
                        selectionMode: SelectionMode.none,
                        source: controller.pointDataSource,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'mRef_No',
                            label: CustomCell(data: LocaleKeys.invoiceNo.tr),
                            columnWidthMode: ColumnWidthMode.auto,
                          ),
                          GridColumn(
                            columnName: 'mDeposit_Date',
                            label: CustomCell(data: LocaleKeys.date.tr),
                          ),
                          GridColumn(
                            columnName: 'mAmount',
                            label: CustomCell(data: LocaleKeys.point.tr),
                          ),
                          GridColumn(
                            columnName: 'mRemark',
                            label: CustomCell(data: LocaleKeys.remarks.tr),
                          ),
                          GridColumn(
                            allowSorting: false,
                            columnName: 'actions',
                            width: 80,
                            label: CustomCell(data: LocaleKeys.operation.tr),
                          ),
                        ],
                        placeholder: NoRecordPermission(
                          msg: controller.hasPermission ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
                        ),
                      ),
                    ),
            ),
          ),
          DataPager(
            totalPages: controller.totalPages,
            totalRecords: controller.totalRecords,
            currentPage: controller.currentPage,
            onPageChanged: (int pageNumber) {
              controller.currentPage = pageNumber;
              controller.updateDepositDataSource();
            },
          ),
        ],
      ),
    );
  }
}
