import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class LoginSheet extends StatelessWidget {
  const LoginSheet({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: LoginSheet(),
      route: Navigate.appendRoute("/auth/login"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModalBottomSheetIndicator(showButton: false, margin: 0),
            GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
            TextBuilder(
              text: "Welcome back!",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22),
              weight: FontWeight.bold,
            ),
            TextBuilder(
              text: "An amazing world of possibilities and wonders, waits for your majestic entrance. Please login to continue.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
            ),
            Image.asset(
              Assets.animGoBeyond,
              fit: BoxFit.fitWidth,
              width: MediaQuery.sizeOf(context).width,
              height: 200,
            ),
            BannerAdLayout(
              expandChild: false,
              child: GetX<LoginController>(
                init: LoginController(),
                builder: (controller) {
                  bool showPassword = controller.state.showPassword.value;

                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmartField.builder(
                        formKey: controller.formKey,
                        items: [
                          FieldItem(
                            hint: "stellmaris@gmail.com",
                            label: "Email Address",
                            controller: controller.emailController,
                            validator: InputValidator.email,
                          ),
                          FieldItem(
                            hint: "#@asdaser1232",
                            label: "Password",
                            isPassword: true,
                            obscureText: showPassword,
                            onVisibilityTapped: controller.state.showPassword.toggle,
                            controller: controller.passwordController,
                            validator: InputValidator.password,
                          ),
                        ],
                        itemBuilder: (context, field, metadata) {
                          return field.copyWith(
                            hint: metadata.item.hint,
                            needLabel: true,
                            replaceHintWithLabel: false,
                            label: metadata.item.label,
                            fillColor: Theme.of(context).appBarTheme.backgroundColor,
                            inputConfigBuilder: (config) => config.copyWith(
                              labelColor: Theme.of(context).primaryColor,
                              labelSize: 14
                            ),
                            inputDecorationBuilder: (dec) => dec.copyWith(
                              enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                              focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            validator: metadata.item.validator,
                            obscureText: metadata.item.obscureText,
                            onPressed: metadata.item.onVisibilityTapped,
                            onTapOutside: (activity) => CommonUtility.unfocus(context),
                            controller: metadata.item.controller,
                          );
                        }
                      ),
                      TextButton(
                        onPressed: ForgotPasswordSheet.open,
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.resolveWith((states) {
                            return CommonColors.instance.bluish.lighten(48);
                          }),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
                        ),
                        child: TextBuilder(
                          text: "Forgot password?",
                          weight: FontWeight.bold,
                          color: CommonColors.instance.bluish
                        )
                      ),
                      InteractiveButton(
                        text: "Sign in",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.instance.color,
                        textColor: CommonColors.instance.lightTheme,
                        onClick: () => controller.login(context),
                        loading: controller.state.isLoading.value
                      ),
                    ],
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}