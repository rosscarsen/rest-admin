import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../routes/app_pages.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/progress_hub.dart';
import '../../../../widgets/custom_cell.dart';
import '../../../../theme/data_grid_theme.dart';
import '../../../../widgets/no_record.dart';
import '../../../../theme/table_input_theme.dart';

import 'set_menu_edit_controller.dart';

class SetMenuEditView extends GetView<SetMenuEditController> {
  const SetMenuEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          centerTitle: true,
          actions: [
            Tooltip(
              message: LocaleKeys.refresh.tr,
              child: IconButton(
                onPressed: () {
                  controller.updateDataGridSource();
                },
                icon: FaIcon(Icons.refresh),
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
                      tabs: controller.tabs,
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
        body: controller.hasPermission
            ? _buildTabBarView(context)
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.thumb_down_alt_outlined, size: 30),
                    SizedBox(height: 8),
                    Text(
                      controller.hasPermission ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
        persistentFooterButtons: [FormHelper.saveButton(onPressed: controller.hasPermission ? controller.save : null)],
      ),
    );
  }

  // 主视图
  Widget _buildTabBarView(BuildContext context) {
    return IndexedStack(
      index: controller.tabIndex.value.clamp(0, controller.tabs.length - 1),
      children: [
        _buildSetMealLimit(context: context),
        _buildSetMeal(context: context),
      ],
    );
  }

  // 套餐限制
  Widget _buildSetMealLimit({required BuildContext context}) {
    return Column(
      children: [
        Skeletonizer(
          enabled: controller.isLoading,
          child: FocusTraversalGroup(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: FormBuilder(
                key: controller.formKey,
                child: FormHelper.buildGridRow(
                  children: [
                    // 编号
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        name: "mCode",
                        labelText: LocaleKeys.code.tr,
                        readOnly: controller.id != null,
                        validator: FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                      ),
                    ),
                    //创建日期
                    FormHelper.buildGridCol(
                      child: FormHelper.dateInput(
                        name: "mDate_Create",
                        labelText: LocaleKeys.createDate.tr,
                        enabled: false,
                        inputType: DateInputType.dateAndTime,
                      ),
                    ),
                    //修改日期
                    FormHelper.buildGridCol(
                      child: FormHelper.dateInput(
                        name: "mDate_Modify",
                        labelText: LocaleKeys.modifyDate.tr,
                        inputType: DateInputType.dateAndTime,
                        enabled: false,
                      ),
                    ),
                    //名称
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(name: "mDesc", labelText: LocaleKeys.name.tr, maxLines: 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: ProgressHUD(
            child: controller.isLoading
                ? null
                : DataGridTheme(
                    child: Theme(
                      data: ThemeData(inputDecorationTheme: tableInputTheme),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfDataGrid(
                          isScrollbarAlwaysShown: true,
                          footerFrozenColumnsCount: 0,
                          frozenColumnsCount: 0,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                          columnSizer: ColumnSizer(),
                          allowSorting: false,
                          showCheckboxColumn: false,
                          source: controller.setMenuLimitSource,
                          columns: <GridColumn>[
                            GridColumn(
                              columnName: "setMealLimit",
                              label: CustomCell(data: LocaleKeys.setMealLimit.tr),
                            ),
                            GridColumn(
                              columnName: 'maxQty',
                              label: CustomCell(data: LocaleKeys.maxQty.tr),
                            ),

                            GridColumn(
                              columnName: 'forceSelect',
                              label: CustomCell(data: LocaleKeys.forceSelect.tr),
                            ),
                            GridColumn(
                              columnName: 'chinese',
                              label: CustomCell(data: LocaleKeys.chinese.tr),
                              allowEditing: true,
                            ),
                            GridColumn(
                              columnName: 'english',
                              label: CustomCell(data: LocaleKeys.english.tr),
                            ),
                          ],
                          placeholder: NoRecordPermission(),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // 套餐
  Widget _buildSetMeal({required BuildContext context}) {
    return Column(
      children: [
        Skeletonizer(
          enabled: controller.isLoading,
          child: FocusTraversalGroup(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: FormHelper.buildGridRow(
                children: [
                  // 选项
                  FormHelper.buildGridCol(
                    child: Row(
                      spacing: 8.0,
                      children: [
                        Expanded(
                          child: FormHelper.selectInput(
                            name: "setMealStep",
                            labelText: LocaleKeys.choice.tr,
                            initialValue: "0",
                            items: List.generate(
                              10,
                              (index) => DropdownMenuItem(
                                value: index.toString(),
                                child: Text(index == 0 ? LocaleKeys.all.tr : index.toString()),
                              ),
                            ),
                            onChanged: (String? val) {
                              controller.searchText = val == "0" ? "" : val ?? "";
                              controller.setMenuDetailSearch(controller.searchText);
                            },
                          ),
                        ),
                        //复制
                        ElevatedButton(onPressed: openSetMeal, child: Text(LocaleKeys.copy.tr)),
                      ],
                    ),
                  ),

                  // 批量刪除套餐 && 添加
                  FormHelper.buildGridCol(
                    sm: 12,
                    md: 12,
                    lg: 12,
                    xl: 12,
                    child: OverflowBar(
                      alignment: MainAxisAlignment.start,
                      spacing: 8,
                      children: [
                        // 批量刪除套餐
                        ElevatedButton(
                          onPressed: () {
                            controller.batchDeleteItems();
                          },
                          child: Text(LocaleKeys.batchDelete.tr),
                        ),
                        // 添加
                        ElevatedButton(
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.OPEN_MULTIPLE_PRODUCT,
                              parameters: {"id": controller.id.toString(), "target": "addSetMenu"},
                            );
                          },
                          child: Text(LocaleKeys.add.tr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ProgressHUD(
            child: controller.isLoading
                ? null
                : SelectionArea(
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        gridLineColor: Colors.grey.shade300,
                        currentCellStyle: DataGridCurrentCellStyle(borderColor: Colors.transparent, borderWidth: 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                        child: SfDataGrid(
                          isScrollbarAlwaysShown: true,
                          controller: controller.setMealDataGridController,
                          footerFrozenColumnsCount: 1,
                          frozenColumnsCount: 1,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          columnWidthMode: ColumnWidthMode.auto,
                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                          columnSizer: ColumnSizer(),
                          allowSorting: false,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          source: controller.setMealDetailSource,
                          columns: <GridColumn>[
                            GridColumn(
                              columnName: "ID",
                              visible: false,
                              label: CustomCell(data: "ID"),
                            ),
                            GridColumn(
                              columnName: "mBarcode",
                              label: CustomCell(data: LocaleKeys.code.tr),
                              columnWidthMode: ColumnWidthMode.auto,
                            ),
                            GridColumn(
                              columnName: 'mName',
                              label: CustomCell(data: LocaleKeys.name.tr),
                              columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                              maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                              minimumWidth: 200,
                            ),
                            GridColumn(
                              columnName: 'mQty',
                              label: CustomCell(data: LocaleKeys.qty.tr),
                            ),
                            GridColumn(
                              columnName: 'mPrice',
                              label: CustomCell(data: LocaleKeys.price.tr),
                            ),
                            GridColumn(
                              columnName: 'mPrice2',
                              label: CustomCell(data: LocaleKeys.scorePrice.tr),
                            ),
                            GridColumn(
                              columnName: 'mStep',
                              label: CustomCell(data: LocaleKeys.option.tr),
                            ),
                            GridColumn(
                              columnName: 'mDefault',
                              label: CustomCell(data: LocaleKeys.defaultSelect.tr),
                            ),
                            GridColumn(
                              columnName: 'mSort',
                              label: CustomCell(data: LocaleKeys.sort.tr),
                            ),
                            GridColumn(
                              columnName: 'mRemarks',
                              label: CustomCell(data: LocaleKeys.remarks.tr),
                              maximumWidth: 500,
                            ),
                            GridColumn(
                              allowSorting: false,
                              columnName: 'actions',
                              width: 100,
                              label: CustomCell(data: LocaleKeys.operation.tr),
                            ),
                          ],
                          placeholder: NoRecordPermission(),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // 打开套餐
  void openSetMeal() async {
    final ret = await Get.toNamed(Routes.OPEN_SET_MEAL);
    final selectCode = (ret?.toString() ?? "").trim();
    if (selectCode.isEmpty) {
      return;
    }
    await controller.copySetMenuDetail(selectCode);
  }
}
