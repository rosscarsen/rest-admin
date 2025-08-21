import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class DataGridTheme extends StatelessWidget {
  /// datagrid 主题
  /// [child] 子组件
  const DataGridTheme({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          gridLineColor: Colors.grey.shade300,
          currentCellStyle: DataGridCurrentCellStyle(
            borderColor: Colors.transparent, // 避免选中单元格边框影响
            borderWidth: 0,
          ),
        ),
        child: child,
      ),
    );
  }
}
