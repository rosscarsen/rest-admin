import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';

class CustomSideBar extends StatelessWidget {
  final List<ExpansionListItem>? expansionList;

  ///自己定义扩展折叠 list view
  const CustomSideBar({super.key, this.expansionList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        ExpansionTileGroup(
          toggleType: ToggleType.expandOnlyCurrent,
          spaceBetweenItem: 10,
          children:
              expansionList?.isEmpty ?? true
                  ? []
                  : expansionList!.map((item) {
                    final onTapGestureDetector = GestureDetector(
                      onTap: item.onTap,
                      child:
                          item.isEnableExpanded == null
                              ? null
                              : // 避免非空断言
                              (item.isEnableExpanded! ? Text(item.title) : Text(item.title)), // 重复利用构建的Text
                    );

                    return ExpansionTileOutlined(
                      leading:
                          item.isEnableExpanded == null
                              ? null
                              : // 避免非空断言
                              (item.isEnableExpanded!
                                  ? Icon(item.leadingIcon)
                                  : GestureDetector(onTap: item.onTap, child: Icon(item.leadingIcon))),
                      trailing:
                          item.isEnableExpanded == null
                              ? null
                              : // 避免非空断言
                              (item.isEnableExpanded!
                                  ? Icon(item.trailingIcon)
                                  : GestureDetector(onTap: item.onTap, child: Icon(item.trailingIcon))),
                      title: onTapGestureDetector,
                      isEnableExpanded: item.isEnableExpanded ?? false, // 提供默认值
                      decoration: BoxDecoration(border: Border.all(style: BorderStyle.none)),
                      children: item.children ?? [], // 修正了此处的条件表达式
                    );
                  }).toList(),
        ),
      ],
    );
  }
}

class ExpansionListItem {
  IconData? leadingIcon;
  String title;
  IconData? trailingIcon;
  bool? isEnableExpanded;
  List<Widget>? children;
  void Function()? onTap;

  ExpansionListItem({
    this.leadingIcon,
    required this.title,
    this.trailingIcon = Icons.chevron_right,
    this.isEnableExpanded = false,
    this.children,
    this.onTap,
  }) : assert(
         (isEnableExpanded == false && onTap != null && children == null) ||
             (isEnableExpanded == true && onTap == null && children != null),
         "当isEnableExpanded为false时必须传入onTap且不能传入children;为true时不能传入onTap且必须传入children",
       );

  @override
  String toString() {
    return 'ExpansionListItem(leadingIcon: $leadingIcon, title: $title, trailingIcon: $trailingIcon, isEnableExpanded: $isEnableExpanded, children: $children, onTap: $onTap)';
  }
}
