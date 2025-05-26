import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../dataSource/employee_data_source.dart';
import '../../model/employee_model.dart';

class DashboardController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  DataPagerController dataPagerController = DataPagerController();
  final employees =
      <Employee>[
        Employee(10001, 'James', 'Project', 20000),
        Employee(10002, 'Kathryn', 'Manager', 30000),
        Employee(10003, 'Lara', 'Developer', 15000),
        Employee(10004, 'Michael', 'Designer', 15000),
        Employee(10005, 'Martin', 'Developer', 15000),
      ].obs;

  late EmployeeDataSource employeeDataSource;

  @override
  void onInit() {
    super.onInit();

    employeeDataSource = EmployeeDataSource(controller: this);
  }

  @override
  void onClose() {
    dataGridController.dispose();
    dataPagerController.dispose();
    super.onClose();
  }

  //删除员工
  void deleteEmployee(Employee employee) {
    employees.value.remove(employee);
    employeeDataSource.updateDataSource(); // 刷新数据源
  }

  //添加员工
  void addEmployee(Employee employee) {
    employees.value.insert(0, employee);
    employeeDataSource.updateDataSource(); // 刷新数据源
  }

  //修改
  void updateEmployee(Employee employee) {
    employees.value[employees.indexWhere((element) => element.id == employee.id)] = employee;
    employeeDataSource.updateDataSource(); // 刷新数据源
  }

  //删除全部
  void deleteAll() {
    employees.value.clear();
    employeeDataSource.updateDataSource(); // 刷新数据源
  }

  //获取选中内容
  void getSelectedContent() {
    /* final List<DataGridRow> selectedRows = dataGridController.selectedRows;
    for (final row in selectedRows) {
      //print(row.getCells().map((e) => e.value).toList().removeLast());
    } */
  }

  //删除选中内容
  void deleteSelectedContent() {
    final List<DataGridRow> selectedRows = dataGridController.selectedRows;
    for (final row in selectedRows) {
      employees.value.remove(row.getCells().map((e) => e.value).toList().removeLast());
    }
    employeeDataSource.updateDataSource();
  }

  // 刷新数据源
  void refreshDataSource() {
    employees.value.addAll([
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
    ]);
    employees.refresh();
    employeeDataSource.updateDataSource();
  }
}

/* class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employeeData, required this.controller}) {
    _employeeData = employeeData.map<DataGridRow>((e) => _createDataRow(e)).toList();
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
    _employeeData = controller.employees.map((e) => _createDataRow(e)).toList();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            if (e.columnName == "actions") {
              Employee employee = e.value as Employee;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteEmployee(employee),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: () => controller.addEmployee(Employee(Random().nextInt(1000), "张三", "工程师", 10000)),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => controller.updateEmployee(Employee(employee.id, "李四", "设计师", 20000)),
                  ),
                ],
              );
            }
            return Container(
              alignment: Alignment.center, // 确保文本在垂直方向和水平方向都居中
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(e.value.toString(), textAlign: TextAlign.center),
            );
          }).toList(),
    );
  }
} */
