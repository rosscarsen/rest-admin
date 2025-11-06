import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../translations/locale_keys.dart';
import 'functions.dart';

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

  /// 分割线
  static ResponsiveGridCol line() {
    return buildGridCol(sm: 12, md: 12, lg: 12, xl: 12, child: Divider(thickness: 0.8));
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
    int maxLines = 1,
    String? initialValue,
    void Function(String?)? onChanged,
    void Function(String?)? onSubmitted,
    bool? enabled,
    bool readOnly = false,
    TextEditingController? controller,
    int? maxDecimalDigits = 2,
    String? errorText,
    String? hintText,
  }) {
    assert(maxLines >= 1, 'maxLines不能小于1');
    assert(!(controller != null && initialValue != null), 'controller 和 initialValue 不能同时设置');

    // 数字正则，提前创建
    final RegExp integerRegex = RegExp(r'^-?\d+$');
    final RegExp decimalRegex = RegExp(r'^-?\d+(\.\d{0,' + maxDecimalDigits.toString() + r'})?$');

    List<TextInputFormatter>? finalInputFormatters = inputFormatters;

    if (keyboardType == TextInputType.number && finalInputFormatters == null) {
      finalInputFormatters = [
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;

          if (text.isEmpty) return newValue;
          if (maxDecimalDigits == 0) {
            if (text == '-') return newValue;
            return integerRegex.hasMatch(text) ? newValue : oldValue;
          }

          if (text == '-' || text == '-.' || text == '.') return newValue;

          return decimalRegex.hasMatch(text) ? newValue : oldValue;
        }),
      ];
    }

    // 保留 Builder 取 FormBuilder 状态，但只包裹状态计算
    return Builder(
      builder: (context) {
        final formEnabled = FormBuilder.of(context)?.enabled ?? true;
        final effectiveEnabled = enabled ?? formEnabled;

        return FormBuilderTextField(
          controller: controller,
          onSubmitted: onSubmitted,
          style: displayTextStyle,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: effectiveEnabled,
          initialValue: initialValue,
          readOnly: readOnly,
          name: name,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          valueTransformer: (value) => (value ?? "").trim(),
          keyboardType: keyboardType ?? (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
          inputFormatters: finalInputFormatters,
          enableSuggestions: true,
          enableInteractiveSelection: true,
          contextMenuBuilder: (context, editableTextState) {
            return AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);
          },
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: !effectiveEnabled || readOnly
                ? OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  )
                : null,
            suffixIcon: suffixIcon,
            fillColor: const Color(0xFFEEEEEE),
            filled: !effectiveEnabled || readOnly,
            errorText: errorText,
          ),
        );
      },
    );
  }

  /// 打开选择器
  static Widget openInput({
    required String name,
    required String labelText,
    required void Function()? onPressed,
    TextEditingController? controller,
    bool? enabled,
    bool readOnly = true,
    void Function()? onClear,
    int? maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    final effectiveController = controller ?? TextEditingController();

    return FormBuilderField<String>(
      name: name,
      validator: validator,
      enabled: enabled ?? true,
      builder: (field) {
        final effectiveEnabled = enabled ?? (FormBuilder.of(field.context)?.enabled ?? true);

        // 保证 controller 与 field.value 同步，同时保留光标
        if (effectiveController.text != (field.value ?? '')) {
          final oldSelection = effectiveController.selection;
          effectiveController.value = TextEditingValue(
            text: field.value ?? '',
            selection: oldSelection.isValid
                ? oldSelection
                : TextSelection.collapsed(offset: (field.value ?? '').length),
          );
        }

        final hasValue = (field.value ?? '').isNotEmpty;
        final iconColor = !effectiveEnabled
            ? Colors.grey
            : hasValue
            ? null
            : Colors.blue;

        void handleSuffixPressed() {
          if (hasValue) {
            // 清空
            field.didChange('');
            effectiveController.clear();
            onClear?.call();
          } else {
            onPressed?.call();
          }
        }

        return TextField(
          controller: effectiveController,
          readOnly: readOnly,
          enabled: effectiveEnabled,
          maxLines: maxLines,
          keyboardType:
              keyboardType ?? ((maxLines == null || maxLines > 1) ? TextInputType.multiline : TextInputType.text),
          onTap: onPressed,
          onChanged: (v) {
            field.didChange(v);
          },
          decoration: InputDecoration(
            label: Text(labelText),
            hintText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            fillColor: !effectiveEnabled ? const Color(0xFFEEEEEE) : null,
            filled: !effectiveEnabled,
            suffixIcon: effectiveEnabled
                ? IconButton(
                    tooltip: hasValue ? LocaleKeys.clearContent.tr : LocaleKeys.openSelect.tr,
                    onPressed: handleSuffixPressed,
                    icon: Icon(hasValue ? Icons.clear : Icons.file_open, color: iconColor),
                  )
                : null,
          ),
        );
      },
    );
  }

  /// 下拉选择框
  static Builder selectInput<T>({
    required String name,
    required String labelText,
    required List<DropdownMenuItem<T>>? items,
    bool? enabled,
    Widget? prefixIcon,
    Widget? prefix,
    FormFieldValidator<T?>? validator,
    T? initialValue,
    void Function(T?)? onChanged,
    Widget? suffixIcon,
    bool allowUnmatchedValue = true, // ✅ 新增参数
  }) {
    return Builder(
      builder: (context) {
        final formEnabled = FormBuilder.of(context)?.enabled ?? true;
        final effectiveEnabled = enabled ?? formEnabled;
        return FormBuilderField<T>(
          name: name,
          enabled: effectiveEnabled,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
              onChanged: effectiveEnabled
                  ? (value) {
                      field.didChange(value);
                    }
                  : null,
              decoration: InputDecoration(
                labelText: labelText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                prefix: prefix,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: !effectiveEnabled
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      )
                    : null,
                fillColor: const Color(0xFFEEEEEE),
                filled: !effectiveEnabled,
              ),
            );
          },
        );
      },
    );
  }

  /// 日期选择框
  static Builder dateInput({
    required String name,
    required String labelText,
    bool? enabled,
    bool? canClear,
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

    return Builder(
      builder: (context) {
        final formEnabled = FormBuilder.of(context)?.enabled ?? true;
        final effectiveEnabled = enabled ?? formEnabled;
        return FormBuilderField<String>(
          name: name,
          enabled: effectiveEnabled,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
              enabled: effectiveEnabled,
              canClear: canClear ?? effectiveEnabled,
              clearIconData: Icons.clear,
              style: displayTextStyle,
              decoration: InputDecoration(
                labelText: labelText,
                prefixIcon: prefixIcon,
                fillColor: effectiveEnabled ? Colors.transparent : const Color(0xFFEEEEEE),
                filled: !effectiveEnabled,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorText: field.errorText,
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 0.7),
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
    OptionsOrientation orientation = OptionsOrientation.wrap,
  }) {
    return FormBuilderCheckboxGroup<String>(
      orientation: orientation,
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      decoration: decoration,
      options: options,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
    String? Function(String?)? validator,
  }) {
    return FormBuilderRadioGroup<String>(
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      valueTransformer: (value) => (value?.toString() ?? "").trim(),
      decoration: decoration,
      validator: validator,
      options: options,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  /// 自动完成输入框
  static Widget autoCompleteInput({
    required String name,
    required String labelText,
    required List<String> items,
    bool enabled = true,
    String? initialValue,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    bool showNoItem = false,
    TextEditingController? controller,
  }) {
    final effectiveController = controller ?? TextEditingController(text: initialValue ?? '');
    return Builder(
      builder: (context) {
        return FormBuilderTypeAhead<String>(
          name: name,
          enabled: enabled,
          initialValue: initialValue,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          valueTransformer: (value) => (value?.toString() ?? "").trim(),
          onChanged: (value) {
            effectiveController.text = value ?? '';
            onChanged?.call(value);
          },
          customTextField: TextField(
            controller: effectiveController,
            onChanged: (value) {
              final formState = FormBuilder.of(context);
              final field = formState?.fields[name];
              field?.didChange(value);
              onChanged?.call(value);
            },
          ),
          decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: effectiveController,
              builder: (context, value, child) {
                return value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          effectiveController.clear();
                          final field = FormBuilder.of(context)?.fields[name];
                          field?.didChange(null);
                          onChanged?.call(null);
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
          itemBuilder: (context, item) {
            return ListTile(title: Text(item));
          },
          emptyBuilder: (context) {
            return !showNoItem
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(LocaleKeys.noDataFound.tr, style: const TextStyle(color: Colors.grey)),
                    ),
                  );
          },
          suggestionsCallback: (query) {
            if (query.isNotEmpty) {
              final lowercaseQuery = query.toLowerCase();
              return items.where((item) => item.toLowerCase().contains(lowercaseQuery)).toList(growable: false)..sort(
                (a, b) => a.toLowerCase().indexOf(lowercaseQuery).compareTo(b.toLowerCase().indexOf(lowercaseQuery)),
              );
            } else {
              return items;
            }
          },
        );
      },
    );
  }

  /// 搜索下拉选择框
  static FormBuilderSearchableDropdown<String> searchableDropdownInput({
    required String name,
    required String labelText,
    required List<String> items,
    bool enabled = true,
    String? initialValue,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    bool showClearButton = true,
  }) {
    return FormBuilderSearchableDropdown<String>(
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      valueTransformer: (value) => (value?.toString() ?? "").trim(),
      decoration: InputDecoration(labelText: labelText, floatingLabelBehavior: FloatingLabelBehavior.always),
      dropdownSearchDecoration: InputDecoration(labelText: labelText),
      asyncItems: (filter, _) async {
        await Future.delayed(const Duration(milliseconds: 300));
        return items.where((element) => element.toLowerCase().contains(filter.toLowerCase())).toList();
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        emptyBuilder: (context, searchEntry) => SizedBox(
          height: 50,
          child: Center(
            child: Text(LocaleKeys.noDataFound.tr, style: const TextStyle(color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  /// 搜索下拉选择框
  static FormBuilderColorPickerField colorInput({
    required String name,
    required String labelText,
    bool enabled = true,
    Color? initialValue,
    void Function(String?)? onChanged,
    String? Function(Color?)? validator,
    bool showClearButton = true,
    bool readOnly = false,
    ColorPickerType colorPickerType = ColorPickerType.colorPicker,
  }) {
    return FormBuilderColorPickerField(
      name: name,
      enabled: enabled,
      readOnly: readOnly,
      initialValue: initialValue ?? Colors.deepPurple,
      colorPickerType: colorPickerType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      valueTransformer: (value) => Functions.colorToHex(value ?? Colors.deepPurple),
      validator: validator,
      onChanged: (Color? color) {
        if (color != null) {
          onChanged?.call(Functions.colorToHex(color));
        } else {
          onChanged?.call(null);
        }
      },
      decoration: InputDecoration(labelText: labelText, floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  /// 手机输入框
  static Widget phoneInput({
    required String name,
    String? labelText,
    bool enabled = true,
    void Function(PhoneNumber?)? onChanged,
    TextEditingController? controller,
    String? initialSelection = "HK",
    bool isRequired = false,
    String? initialValue,
  }) {
    final effectiveController = controller ?? TextEditingController();

    return FormBuilderField<PhoneNumber>(
      name: name,
      enabled: enabled,
      initialValue: () {
        if (initialValue == null || initialValue.trim().isEmpty) {
          return PhoneNumber.parse("+852");
        }
        try {
          return PhoneNumber.parse(initialValue);
        } catch (e) {
          return PhoneNumber.parse("+852");
        }
      }(),
      autovalidateMode: AutovalidateMode.onUserInteraction, // 自动验证
      validator: (PhoneNumber? value) {
        if (isRequired && (value == null || value.nsn.isEmpty)) {
          return LocaleKeys.thisFieldIsRequired.tr;
        }

        if (value != null && value.nsn.isNotEmpty && !value.isValid()) {
          return LocaleKeys.invalidMobileNumber.tr;
        }

        return null;
      },

      valueTransformer: (value) => (value == null || value.nsn.isEmpty) ? "" : value.international,
      builder: (FormFieldState<PhoneNumber> field) {
        final selectedIsoCode = field.value?.isoCode ?? IsoCode.fromJson(initialSelection!);
        final selectedPhoneNumber = field.value?.nsn ?? "";

        if (field.value != null && effectiveController.text != selectedPhoneNumber) {
          effectiveController.text = selectedPhoneNumber;
        }

        return TextField(
          enabled: enabled,
          controller: effectiveController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            if (value.isEmpty) {
              final phoneNumber = PhoneNumber(isoCode: selectedIsoCode, nsn: "");
              field.didChange(phoneNumber);
              onChanged?.call(phoneNumber);
              return;
            }

            final regex = RegExp(r'^[0-9]+$');
            if (regex.hasMatch(value)) {
              final phoneNumber = PhoneNumber(isoCode: selectedIsoCode, nsn: value);
              field.didChange(phoneNumber);
              onChanged?.call(phoneNumber);
            }
          },
          decoration: InputDecoration(
            labelText: labelText ?? LocaleKeys.mobile.tr,
            errorText: field.errorText, // 关键：显示错误
            prefixIcon: IgnorePointer(
              ignoring: !enabled,
              child: CountryCodePicker(
                onChanged: (code) {
                  final nsn = effectiveController.text;
                  final iso = IsoCode.fromJson(code.code ?? "HK");
                  final phoneNumber = PhoneNumber(isoCode: iso, nsn: nsn);
                  field.didChange(phoneNumber);
                  onChanged?.call(phoneNumber);
                },
                initialSelection: selectedIsoCode.name,
                favorite: ['+852', '+86', '+853', '+886', 'US'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                headerText: LocaleKeys.selectCountry.tr,
                searchDecoration: InputDecoration(hintText: LocaleKeys.search.tr),
                emptySearchBuilder: (context) {
                  return Center(
                    child: Text(LocaleKeys.noDataFound.tr, style: TextStyle(color: Colors.grey)),
                  );
                },
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        );
      },
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

  /// 取消按鈕
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
