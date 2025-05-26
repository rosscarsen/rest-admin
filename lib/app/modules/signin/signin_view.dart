import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../config.dart';
import '../../translations/locale_keys.dart';
import '../../widgets/popup_lang.dart';
import 'signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: controller.animationController, curve: Curves.bounceIn)),
                      child: Container(
                        alignment: Alignment.center,
                        height: 160,
                        child: FittedBox(
                          child: GradientAnimationText(
                            text: Text('Rest Admin', style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold)),
                            colors: [
                              Color(0xff8f00ff),
                              Colors.indigo,
                              Colors.blue,
                              Colors.green,
                              Colors.yellow,
                              Colors.orange,
                              Colors.red,
                            ],
                            duration: Duration(seconds: 5),
                          ),
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        double designWidth = constraints.maxWidth > 480 ? 320 : constraints.maxWidth * 0.9;
                        return SizedBox(
                          width: designWidth,
                          child: SingleChildScrollView(child: BuildForm(context)),
                        ).marginSymmetric(horizontal: designWidth > 380 ? Get.width * 0.08 : 30);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(right: 5, top: 5, child: PopupLang()),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildForm(BuildContext context) {
    bool visibility = false;
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(isDense: false)),
      child: FormBuilder(
        key: SigninController.to.formKey,
        child: Column(
          spacing: Config.defaultGap,
          children: [
            //公司
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.apartment),
                hintText: LocaleKeys.company.tr,
                suffixIcon: IconButton(
                  onPressed: () {
                    SigninController.to.formKey.currentState!.fields['company']?.reset();
                  },
                  icon: Icon(Icons.cancel),
                ),
              ),
              name: "company",
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
              ]),
            ),
            //用户
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: LocaleKeys.user.tr,
                suffixIcon: IconButton(
                  onPressed: () {
                    SigninController.to.formKey.currentState!.fields['user']?.reset();
                  },
                  icon: Icon(Icons.cancel),
                ),
              ),
              name: "user",
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
              ]),
            ),

            //密码
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                return FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.verified_user),
                    hintText: LocaleKeys.password.tr,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                      icon: Icon(!visibility ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  name: "password",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                  obscureText: !visibility,
                );
              },
            ),

            //记住按钮
            FormBuilderCheckbox(
              activeColor: Colors.green,
              initialValue: true,
              name: "rememberMe",
              title: Text(LocaleKeys.rememberMe.tr, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            //登录按钮
            SizedBox(
              width: double.infinity,
              child: RoundedLoadingButton(
                width: Get.width,
                color: Colors.green,
                successColor: Colors.amber,
                controller: SigninController.to.signInController,
                onPressed: () async {
                  await SigninController.to.signIn();
                },
                valueColor: Colors.black,
                borderRadius: 10,
                child: Text(LocaleKeys.login.tr, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
