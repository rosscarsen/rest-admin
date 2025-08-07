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
  static const displayTextStyle = TextStyle(fontSize: 16, color: Colors.black87);

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

  /// 网格列
  static ResponsiveGridCol buildGridCol({
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    required Widget child,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: child,
      ),
    );
  }

  /// 文本输入框
  static Widget textInput({
    required String name,
    required String labelText,
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
    bool readOnly = false,
    TextEditingController? controller,
    int? maxDecimalDigits = 2,
    String? errorText,
  }) {
    assert(maxLines >= 1, 'maxLines不能小于1');
    return FormBuilderTextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: displayTextStyle,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      initialValue: initialValue,
      readOnly: readOnly,
      name: name,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      obscureText: obscureText,
      valueTransformer: (value) => (value ?? "").trim(),
      decoration: InputDecoration(
        labelText: labelText,
        //prefixIcon: prefixIcon ?? buildPrefixIconText(labelText, enabled),
        prefixIconConstraints: const BoxConstraints(maxWidth: _prefixIconMaxWidth),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: !enabled || readOnly
            ? OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              )
            : null,
        suffixIcon: suffixIcon,
        fillColor: Colors.grey.shade200,
        filled: !enabled || readOnly,
        errorText: errorText,
      ),
      keyboardType: keyboardType ?? (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      inputFormatters: keyboardType == TextInputType.number
          ? inputFormatters ??
                (maxDecimalDigits == 0
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : [
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
                      ])
          : null,
      //textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.done,
      enableSuggestions: true,
      enableInteractiveSelection: true,
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);
      },
    );
  }

  /// 下拉选择框
  static FormBuilderField selectInput<T>({
    required String name,
    required String labelText,
    required List<DropdownMenuItem<T>>? items,
    bool enabled = true,
    Widget? prefixIcon,
    FormFieldValidator<T?>? validator,
    T? initialValue,
    void Function(T?)? onChanged,
    Widget? suffixIcon,
    bool allowUnmatchedValue = true, // ✅ 新增参数
  }) {
    return FormBuilderField<T>(
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      valueTransformer: (value) => (value?.toString() ?? "").trim(),
      builder: (field) {
        T? currentValue = field.value;
        List<DropdownMenuItem<T>> safeItems = items ?? [];

        // ✅ 如果允许非法值，且当前值不在选项中，加入一个“隐藏项”
        bool valueNotInList = currentValue != null && safeItems.where((item) => item.value == currentValue).isEmpty;

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
          style: displayTextStyle,
          value: currentValue,
          items: safeItems,
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          onChanged: enabled ? (val) => field.didChange(val) : null,
          onSaved: field.didChange,
          decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: suffixIcon,
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
  }

  /// 日期选择框
  static FormBuilderField dateInput({
    required String name,
    required String labelText,
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

    return FormBuilderField<String>(
      name: name,
      enabled: enabled,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      valueTransformer: (value) => (value?.toString() ?? "").trim(),
      initialValue: initialValue != null ? effectiveDateFormat.format(initialValue) : null,
      builder: (field) {
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
          style: displayTextStyle,
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
  }

  ///多选框组
  static FormBuilderCheckboxGroup checkboxGroup({
    required String name,
    required String labelText,
    required List<FormBuilderFieldOption<String>> options,
    bool enabled = true,
    List<String>? initialValue,
    void Function(List<String>?)? onChanged,
  }) {
    return FormBuilderCheckboxGroup<String>(
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
    );
  }

  /// 单个复选框
  static FormBuilderCheckbox checkbox({
    required String name,
    required String labelText,
    bool enabled = true,
    bool? initialValue,
    void Function(bool?)? onChanged,
  }) {
    return FormBuilderCheckbox(
      name: name,
      initialValue: initialValue ?? false,
      enabled: enabled,
      onChanged: onChanged,
      title: Text(labelText),
    );
  }

  /// 开关（Switch）
  static FormBuilderSwitch switchInput({
    required String name,
    required String labelText,
    bool enabled = true,
    bool? initialValue,
    void Function(bool?)? onChanged,
  }) {
    return FormBuilderSwitch(
      name: name,
      title: Text(labelText),
      enabled: enabled,
      initialValue: initialValue,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  ///单选（RadioGroup）
  static FormBuilderRadioGroup radioGroup({
    required String name,
    required String labelText,
    required List<FormBuilderFieldOption<String>> options,
    bool enabled = true,
    String? initialValue,
    void Function(String?)? onChanged,
  }) {
    return FormBuilderRadioGroup<String>(
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
    );
  }

  ///滑块（Slider）
  static FormBuilderSlider slider({
    required String name,
    required String labelText,
    double min = 0,
    double max = 100,
    int divisions = 10,
    double? initialValue,
    bool enabled = true,
    void Function(double?)? onChanged,
  }) {
    return FormBuilderSlider(
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
