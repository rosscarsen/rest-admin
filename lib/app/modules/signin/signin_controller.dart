import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../config.dart';
import '../../model/login/login_model.dart';
import '../../routes/app_pages.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../translations/locale_keys.dart';
import '../../utils/custom_alert.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/logger.dart';
import '../../utils/storage_manage.dart';

class SigninController extends GetxController with GetSingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get formKey => _formKey;
  static SigninController get to => Get.find();
  final StorageManage storageManage = StorageManage();
  final RoundedLoadingButtonController signInController = RoundedLoadingButtonController();
  late AnimationController animationController;
  final ApiClient apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void onReady() {
    getLoginInfo();
    super.onReady();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  //获取本地存储的用户信息
  void getLoginInfo() {
    var loginUserJson = storageManage.read(Config.localStorageLoginInfo);
    LoginResult? loginUser = loginUserJson != null ? LoginResult.fromJson(loginUserJson) : null;
    bool rememberMe = storageManage.read(Config.rememberMe) ?? false;
    logger.f(rememberMe);
    if (rememberMe && loginUser != null && _formKey.currentState != null) {
      _formKey.currentState!.fields['company']?.didChange(loginUser.company);
      _formKey.currentState!.fields['user']?.didChange(loginUser.user);
      _formKey.currentState!.fields['password']?.didChange(loginUser.pwd);
    }
  }

  //远程登录
  Future<void> signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final Map<String, dynamic> loginFormData = _formKey.currentState!.value;

      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.login, data: loginFormData);
        if (!dioApiResult.success) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
          return;
        }
        if (!dioApiResult.hasPermission) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.noPermission.tr);
          return;
        }
        if (dioApiResult.data == null) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
          return;
        }

        final loginModel = loginModelFromJson(dioApiResult.data!);
        switch (loginModel.status) {
          case 200:
            final storageManage = StorageManage();
            logger.f(loginModel.apiResult?.toJson());
            await storageManage.write(Config.localStorageLoginInfo, loginModel.apiResult?.toJson());
            await storageManage.write(Config.localStorageHasLogin, true);
            if (loginFormData['rememberMe'] == true) {
              await storageManage.write(Config.rememberMe, true);
            } else {
              await storageManage.write(Config.rememberMe, false);
            }
            signInController.success();
            await Future.delayed(const Duration(seconds: 1), () => Get.offAndToNamed(Routes.DASHBOARD));
            break;
          case 201:
            CustomAlert.iosAlert(message: LocaleKeys.userLoggedIn.tr);
            break;
          case 202:
            CustomAlert.iosAlert(message: LocaleKeys.companyError.tr);
            break;
          case 203:
            CustomAlert.iosAlert(message: LocaleKeys.loginLimit.tr);
            break;
          case 204:
            CustomAlert.iosAlert(message: LocaleKeys.userOrPasswordError.tr);
            break;
          default:
            CustomAlert.iosAlert(message: LocaleKeys.unknownError.tr);
            break;
        }
      } finally {
        await Future.delayed(const Duration(seconds: 1));
        signInController.reset();
      }
    } else {
      signInController.error();
      await Future.delayed(const Duration(seconds: 1));
      signInController.reset();
    }
  }
}
