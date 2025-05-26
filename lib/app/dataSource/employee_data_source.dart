import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/employee_model.dart';
import '../modules/dashboard/dashboard_controller.dart';

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required this.controller}) {
    updateDataSource();
  }

  final DashboardController controller;
  List<DataGridRow> _employeeData = [];

  DataGridRow _createDataRow(Employee e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<String>(columnName: 'name', value: e.name),
        DataGridCell<String>(columnName: 'designation', value: e.designation),
        DataGridCell<int>(columnName: 'salary', value: e.salary),
        DataGridCell<String>(columnName: 'photo', value: e.photo),
        DataGridCell<Employee>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataSource() {
    _employeeData = controller.employees.map(_createDataRow).toList();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            if (e.columnName == "actions") {
              Employee employee = e.value as Employee;
              if (Get.context!.width < 600) {
                return PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.add),
                            title: Text("添加"),
                            onTap: () => controller.addEmployee(Employee(Random().nextInt(1000), "张三", "工程师", 10000)),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("编辑"),
                            onTap: () => controller.updateEmployee(Employee(employee.id, "李四", "设计师", 20000)),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("删除"),
                            onTap: () => controller.deleteEmployee(employee),
                          ),
                        ),
                      ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Flexible(
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteEmployee(employee),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () => controller.addEmployee(Employee(Random().nextInt(1000), "张三", "工程师", 10000)),
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => controller.updateEmployee(Employee(employee.id, "李四", "设计师", 20000)),
                      ),
                    ),
                  ],
                );
              }
            }
            if (e.columnName == "photo") {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  child: Image.network(e.value.toString()),
                  onTap: () {
                    //print(e.value);
                  },
                ),
              );
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(e.value.toString(), textAlign: TextAlign.center),
            );
          }).toList(),
    );
  }
}
