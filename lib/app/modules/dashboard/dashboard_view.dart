import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DashboardView')),
      body: SelectionArea(
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            gridLineColor: Colors.grey, // 统一表格线颜色
            currentCellStyle: DataGridCurrentCellStyle(
              borderColor: Colors.transparent, // 避免选中单元格边框影响
              borderWidth: 0,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SfDataGrid(
                      isScrollbarAlwaysShown: false,
                      controller: controller.dataGridController,
                      footerFrozenColumnsCount: 1,
                      frozenColumnsCount: 1,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      columnWidthMode: ColumnWidthMode.auto,
                      allowSorting: true,
                      showCheckboxColumn: true,
                      selectionMode: SelectionMode.multiple,
                      onCellTap: (details) {
                        //print(details.rowColumnIndex);
                      },

                      source: controller.employeeDataSource,
                      /* onQueryRowHeight: (details) {
                    return details.getIntrinsicRowHeight(details.rowIndex);
                  }, */
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'id',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('user or password error'.tr, textAlign: TextAlign.center),
                          ),
                        ),
                        GridColumn(
                          columnName: 'name',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Name'),
                          ),
                        ),
                        GridColumn(
                          columnName: 'designation',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Designation', overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        GridColumn(
                          columnName: 'salary',
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Salary'),
                          ),
                        ),
                        GridColumn(
                          allowSorting: false,
                          columnName: 'photo',
                          width: 130,
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('操作'),
                          ),
                        ),
                        GridColumn(
                          allowSorting: false,
                          columnName: 'actions',
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('操作'),
                          ),
                        ),
                      ],
                    ).paddingAll(5),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey, width: 1)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Obx(() {
                          return SfDataPagerTheme(
                            data: SfDataPagerThemeData(
                              itemTextStyle: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 65, 65, 65)),
                              selectedItemTextStyle: TextStyle(fontSize: 16, color: Colors.white),
                              selectedItemColor: Theme.of(context).primaryColor,
                            ),
                            child: SfDataPager(
                              controller: controller.dataPagerController,
                              initialPageIndex: 1,
                              visibleItemsCount: 5,
                              direction: Axis.horizontal,
                              pageCount: (controller.employees.value.length / 5).ceilToDouble(),
                              delegate: controller.employeeDataSource,
                              onPageNavigationEnd: (int pageIndex) {
                                //print("用户点击的页码: ${pageIndex + 1}");
                              },
                            ),
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.getSelectedContent();
                              },
                              child: Text('Get Selected Content'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.deleteAll();
                              },
                              child: Text('Delete All'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.refreshDataSource();
                              },
                              child: Text('refresh'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
