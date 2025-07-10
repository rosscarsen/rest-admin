import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../translations/locale_keys.dart';
import 'constants.dart';

enum DateInputType { time, date, dateAndTime }

class FormHelper {
  static const double _horizontalPadding = 4.0;
  static const double _verticalPadding = 4.0;
  static const double _prefixIconMaxWidth = 110;

  /// 构建左侧 label 样式
  static Widget _buildPrefixIconText(String text, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SelectableText(
        "$text :",
        style: TextStyle(
          color: enabled ? AppColors.enableColor : AppColors.disableColor,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// 文本输入框
  static ResponsiveGridCol textInput({
    required String name,
    required String labelText,
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    Widget? prefixIcon,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    void Function(String?)? onSaved,
    Widget? suffixIcon,
    bool obscureText = false,
    int maxLines = 1,
    String? initialValue,
    void Function(String?)? onChanged,
    void Function(String?)? onSubmitted,
    bool enabled = true,
    bool isVisible = true, // 控制可见性的状态
    TextEditingController? controller,
    int? maxDecimalDigits = 2,
  }) {
    assert(maxLines >= 1, 'maxLines不能小于1');
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: Builder(
          builder: (context) {
            return FormBuilderTextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: Theme.of(context).textTheme.bodyLarge,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: enabled,
              initialValue: initialValue,
              name: name,
              maxLines: maxLines,
              validator: validator,
              onSaved: onSaved,
              onChanged: onChanged,
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: labelText,
                //prefixIcon: prefixIcon ?? buildPrefixIconText(labelText, enabled),
                prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: !enabled
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      )
                    : null,
                suffixIcon: suffixIcon,
                fillColor: Colors.grey.shade200,
                filled: !enabled,
              ),
              keyboardType: keyboardType ?? (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
              inputFormatters: keyboardType == TextInputType.number
                  ? inputFormatters ??
                        [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final text = newValue.text;

                            if (text.isEmpty) return newValue;
                            if (text == '.') return oldValue; // 禁止首个字符为小数点
                            final regex = RegExp(r'^\d+(\.\d{0,' + maxDecimalDigits.toString() + r'})?$');
                            if (regex.hasMatch(text)) {
                              return newValue;
                            }
                            return oldValue;
                          }),
                        ]
                  : null,
              //textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.done,
              enableSuggestions: true,
              enableInteractiveSelection: true,
              contextMenuBuilder: (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);
              },
            );
          },
        ),
      ),
    );
  }

  /// 下拉选择框
  static ResponsiveGridCol selectInput<T>({
    required String name,
    required String labelText,
    required List<DropdownMenuItem<T>>? items,
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    bool enabled = true,
    Widget? prefixIcon,
    FormFieldValidator<T?>? validator,
    T? initialValue,
    void Function(T?)? onChanged,
    bool allowUnmatchedValue = true, // ✅ 新增参数
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderField<T>(
          name: name,
          enabled: enabled,
          initialValue: initialValue,
          validator: validator,
          onChanged: onChanged,
          builder: (field) {
            return Builder(
              builder: (context) {
                T? currentValue = field.value;
                List<DropdownMenuItem<T>> safeItems = items ?? [];

                // ✅ 如果允许非法值，且当前值不在选项中，加入一个“隐藏项”
                bool valueNotInList =
                    currentValue != null && safeItems.where((item) => item.value == currentValue).isEmpty;

                if (allowUnmatchedValue && valueNotInList) {
                  safeItems = [
                    DropdownMenuItem<T>(
                      value: currentValue,
                      child: Text("${LocaleKeys.invalidItem.tr} $currentValue"), // 不显示该项
                    ),
                    ...safeItems,
                  ];
                }

                return DropdownButtonFormField<T>(
                  style: Theme.of(context).textTheme.bodyLarge,
                  value: currentValue,
                  items: safeItems,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(8),
                  onChanged: enabled ? (val) => field.didChange(val) : null,
                  onSaved: field.didChange,
                  decoration: InputDecoration(
                    labelText: labelText,
                    //prefixIcon: prefixIcon ?? buildPrefixIconText(labelText, enabled),
                    prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: !enabled
                        ? OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    fillColor: Colors.grey.shade200,
                    filled: !enabled,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// 日期选择框
  static ResponsiveGridCol dateInput({
    required String name,
    required String labelText,
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    bool enabled = true,
    bool canClear = true,
    FormFieldValidator<String?>? validator,
    DateTime? initialValue,
    void Function(String?)? onSaved,
    void Function(String?)? onChanged,
    DateTime? firstDate,
    DateTime? lastDate,
    DateInputType inputType = DateInputType.date,
    DateFormat? dateFormat,
    Widget? prefixIcon,
  }) {
    final effectiveDateFormat =
        dateFormat ??
        {
          DateInputType.time: DateFormat.Hm(),
          DateInputType.date: DateFormat('yyyy-MM-dd'),
          DateInputType.dateAndTime: DateFormat('yyyy-MM-dd HH:mm:ss'),
        }[inputType]!;

    final mode = {
      DateInputType.time: DateTimeFieldPickerMode.time,
      DateInputType.date: DateTimeFieldPickerMode.date,
      DateInputType.dateAndTime: DateTimeFieldPickerMode.dateAndTime,
    }[inputType]!;

    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderField<String>(
          name: name,
          enabled: enabled,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          initialValue: initialValue != null ? effectiveDateFormat.format(initialValue) : null,
          builder: (field) {
            return Builder(
              builder: (context) {
                // 安全地将 field.value 字符串转为 DateTime，如果失败则为 null
                DateTime? getDateTimeFromValue(String? value) {
                  if (value == null || value.isEmpty) return null;
                  try {
                    return DateTime.tryParse(value) ?? effectiveDateFormat.parseStrict(value); // 尝试 ISO 格式或用户格式
                  } catch (e) {
                    return null;
                  }
                }

                return DateTimeFormField(
                  initialValue: getDateTimeFromValue(field.value),
                  enabled: enabled,
                  canClear: canClear,
                  clearIconData: Icons.cancel,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: labelText,
                    prefixIcon: prefixIcon,
                    prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
                    fillColor: enabled ? Colors.transparent : Colors.grey.shade200,
                    filled: !enabled,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  mode: mode,
                  dateFormat: effectiveDateFormat,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  pickerPlatform: DateTimeFieldPickerPlatform.adaptive,
                  onChanged: (val) => field.didChange(val != null ? effectiveDateFormat.format(val) : null),
                  onSaved: (val) => field.didChange(val != null ? effectiveDateFormat.format(val) : null),
                );
              },
            );
          },
        ),
      ),
    );
  }

  ///多选框组
  static ResponsiveGridCol checkboxGroup({
    required String name,
    required String labelText,
    required List<FormBuilderFieldOption<String>> options,
    int xs = 12,
    int? sm = 12,
    int? md = 12,
    int? lg = 12,
    int? xl = 12,
    bool enabled = true,
    List<String>? initialValue,
    void Function(List<String>?)? onChanged,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderCheckboxGroup<String>(
          name: name,
          enabled: enabled,
          initialValue: initialValue,
          decoration: InputDecoration(
            prefixIcon: _buildPrefixIconText(labelText, enabled),
            prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
            border: InputBorder.none,
          ),
          options: options,
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// 单个复选框
  static ResponsiveGridCol checkbox({
    required String name,
    required String labelText,
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    bool enabled = true,
    bool? initialValue,
    void Function(bool?)? onChanged,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderCheckbox(
          name: name,
          initialValue: initialValue ?? false,
          enabled: enabled,
          onChanged: onChanged,
          title: Text(labelText),
        ),
      ),
    );
  }

  /// 开关（Switch）
  static ResponsiveGridCol switchInput({
    required String name,
    required String labelText,
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    bool enabled = true,
    bool? initialValue,
    void Function(bool?)? onChanged,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderSwitch(
          name: name,
          title: Text(labelText),
          enabled: enabled,
          initialValue: initialValue,
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }

  ///单选（RadioGroup）
  static ResponsiveGridCol radioGroup({
    required String name,
    required String labelText,
    required List<FormBuilderFieldOption<String>> options,
    int xs = 12,
    int? sm = 12,
    int? md = 12,
    int? lg = 12,
    int? xl = 12,
    bool enabled = true,
    String? initialValue,
    void Function(String?)? onChanged,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderRadioGroup<String>(
          name: name,
          enabled: enabled,
          initialValue: initialValue,
          decoration: InputDecoration(
            prefixIcon: _buildPrefixIconText(labelText, enabled),
            prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
            border: InputBorder.none,
          ),
          options: options,
          onChanged: onChanged,
        ),
      ),
    );
  }

  ///滑块（Slider）
  static ResponsiveGridCol slider({
    required String name,
    required String labelText,
    double min = 0,
    double max = 100,
    int divisions = 10,
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    double? initialValue,
    bool enabled = true,
    void Function(double?)? onChanged,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: FormBuilderSlider(
          name: name,
          initialValue: initialValue ?? min,
          min: min,
          max: max,
          divisions: divisions,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: _buildPrefixIconText(labelText, enabled),
            prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// 按鈕
  static FilledButton button({required void Function()? onPressed, Widget? icon, String? label}) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon ?? FaIcon(FontAwesomeIcons.floppyDisk),
      label: Text(label ?? LocaleKeys.save.tr, style: TextStyle(fontSize: 16)),
    );
  }
}
