import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../translations/locale_keys.dart';
import 'constants.dart';
import 'custom_dialog.dart';

enum DateInputType { time, date, dateAndTime }

class FormHelper {
  static const double _horizontalPadding = 4.0;
  static const double _verticalPadding = 4.0;
  //static const double _prefixIconMaxWidth = 110;
  static const displayTextStyle = TextStyle(fontSize: 16, color: Colors.black87);

  /// 构建左侧 label 样式
  // static Widget _buildPrefixIconText(String text, bool enabled) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8.0),
  //     child: SelectableText(
  //       "$text :",
  //       style: TextStyle(
  //         color: enabled ? AppColors.enableColor : AppColors.disableColor,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ),
  //   );
  // }

  /// 构建网格行
  static ResponsiveGridRow buildGridRow({required List<ResponsiveGridCol> children}) {
    return ResponsiveGridRow(children: children);
  }

  /// 网格列
  static ResponsiveGridCol buildGridCol({
    int xs = 12,
    int? sm = 6,
    int? md = 4,
    int? lg = 4,
    int? xl = 4,
    double horizontal = _horizontalPadding,
    double vertical = _verticalPadding,
    required Widget child,
  }) {
    return ResponsiveGridCol(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
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
    String? hintText,
  }) {
    assert(maxLines >= 1, 'maxLines不能小于1');
    assert(!(controller != null && initialValue != null), 'controller 和 initialValue 不能同时设置');
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
      onChanged: onChanged,
      obscureText: obscureText,
      valueTransformer: (value) => (value ?? "").trim(),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
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

  /// 打开选择器
  static Widget openInput({
    required String name,
    required String labelText,
    required void Function()? onPressed,
    TextEditingController? controller,
    bool readOnly = true,
  }) {
    final effectiveController = controller ?? TextEditingController();
    return ValueListenableBuilder(
      valueListenable: effectiveController,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return GestureDetector(
          onTap: onPressed,
          child: AbsorbPointer(
            absorbing: effectiveController.text.isEmpty,
            child: FormBuilderTextField(
              controller: effectiveController,
              readOnly: readOnly,
              style: displayTextStyle,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: name,
              valueTransformer: (value) => (value ?? "").trim(),
              decoration: InputDecoration(
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                suffixIcon: effectiveController.text.isNotEmpty
                    ? IconButton(
                        tooltip: LocaleKeys.clearContent.tr,
                        onPressed: () => effectiveController.clear(),
                        icon: Icon(Icons.cancel),
                      )
                    : IconButton(
                        tooltip: LocaleKeys.openChoice.tr,
                        onPressed: onPressed,
                        icon: Icon(Icons.file_open, color: AppColors.openColor),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 打开选择文件
  static Widget openFileInput({
    required String name,
    required String labelText,
    required TextEditingController controller,
    required void Function(File? file)? onFileSelected,
    List<String> allowedExtensions = const ['xlsx', 'xls'],
    IconData prefixIcon = FontAwesomeIcons.fileExcel,
    bool readOnly = true,
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        File? selectedFile;

        Future<void> pickFile() async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: allowedExtensions,
            dialogTitle: LocaleKeys.selectFile.trArgs(["excel"]),
            lockParentWindow: true,
          );
          if (result != null) {
            setState(() {
              PlatformFile platformFile = result.files.single;
              selectedFile = File(platformFile.path!);
              controller.text = platformFile.name;
            });
            onFileSelected?.call(selectedFile);
          } else {
            CustomDialog.showToast(LocaleKeys.userCanceledPicker.tr);
          }
        }

        return GestureDetector(
          onTap: pickFile,
          child: AbsorbPointer(
            absorbing: controller.text.isEmpty,
            child: TextField(
              readOnly: readOnly,
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: Icon(prefixIcon, color: AppColors.openColor),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            selectedFile = null;
                            controller.clear();
                          });
                          onFileSelected?.call(null);
                        },
                      )
                    : IconButton(
                        tooltip: LocaleKeys.openChoice.tr,
                        onPressed: pickFile,
                        icon: Icon(Icons.file_open, color: AppColors.openColor),
                      ),
              ),
            ),
          ),
        );
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
          initialValue: currentValue,
          items: safeItems,
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          onChanged: enabled
              ? (value) {
                  field.didChange(value);
                }
              : null,
          decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
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
    dynamic initialValue, // ✅ 支持 DateTime 或 String
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

    // ✅ 统一转换 initialValue 为字符串（内部统一逻辑）
    String? normalizeInitialValue(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return effectiveDateFormat.format(value);
      if (value is String && value.trim().isNotEmpty) return value.trim();
      return null;
    }

    return FormBuilderField<String>(
      name: name,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      valueTransformer: (value) => (value?.toString() ?? "").trim(),
      initialValue: normalizeInitialValue(initialValue),
      builder: (field) {
        DateTime? getDateTimeFromValue(String? value) {
          if (value == null || value.isEmpty) return null;
          try {
            final iso = DateTime.tryParse(value);
            if (iso != null) return iso;

            String normalized = value;

            if (inputType == DateInputType.time && RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(normalized)) {
              normalized = normalized.substring(0, 5);
            }
            if (inputType == DateInputType.dateAndTime &&
                RegExp(r'^\d{4}[-/]\d{2}[-/]\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(normalized)) {
              normalized = normalized.substring(0, 16);
            }
            if (inputType == DateInputType.date && RegExp(r'^\d{4}/\d{2}/\d{2}$').hasMatch(normalized)) {
              normalized = normalized.replaceAll('/', '-');
            }

            return effectiveDateFormat.parseStrict(normalized);
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
    InputDecoration decoration = const InputDecoration(),
  }) {
    return FormBuilderCheckboxGroup<String>(
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      decoration: decoration,
      options: options,
      onChanged: onChanged,
    );
  }

  /// 单个复选框
  /* static FormBuilderCheckbox checkbox({
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
      valueTransformer: (value) => value == true ? "1" : "0",
      title: Text(labelText),
    );
  } */

  static FormBuilderField<bool?> checkbox({
    required String name,
    required String labelText,
    bool enabled = true,
    bool? initialValue,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
    void Function(bool?)? onChanged,
  }) {
    return FormBuilderField<bool?>(
      name: name,
      enabled: enabled,
      initialValue: initialValue ?? false,
      valueTransformer: (value) => value == true ? "1" : "0",
      builder: (FormFieldState<bool?> field) {
        return CheckboxListTile(
          controlAffinity: controlAffinity,
          contentPadding: EdgeInsets.zero,
          dense: true,
          isThreeLine: false,
          title: Text(labelText),
          value: field.value,
          onChanged: (value) {
            field.didChange(value);
            onChanged?.call(value);
          },
        );
      },
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
      valueTransformer: (value) => value == true ? "1" : "0",
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
    InputDecoration decoration = const InputDecoration(),
  }) {
    return FormBuilderRadioGroup<String>(
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      valueTransformer: (value) => (value?.toString() ?? "").trim(),
      decoration: decoration,
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
    InputDecoration decoration = const InputDecoration(),
  }) {
    return FormBuilderSlider(
      name: name,
      initialValue: initialValue ?? min,
      min: min,
      max: max,
      divisions: divisions,
      enabled: enabled,
      decoration: decoration,
      onChanged: onChanged,
    );
  }

  /// 按鈕
  static FilledButton saveButton({required void Function()? onPressed, Widget? icon, String? label}) {
    return FilledButton.icon(
      onPressed: onPressed == null
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              onPressed.call();
            },
      icon: icon ?? FaIcon(FontAwesomeIcons.floppyDisk),
      label: Text(label ?? LocaleKeys.save.tr, style: TextStyle(fontSize: 16)),
    );
  }

  static ElevatedButton cancelButton({required void Function()? onPressed, Widget? icon, String? label}) {
    return ElevatedButton.icon(
      onPressed: onPressed == null
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              onPressed.call();
            },
      icon: icon ?? FaIcon(FontAwesomeIcons.deleteLeft),
      label: Text(label ?? LocaleKeys.cancel.tr, style: TextStyle(fontSize: 16)),
    );
  }
}
