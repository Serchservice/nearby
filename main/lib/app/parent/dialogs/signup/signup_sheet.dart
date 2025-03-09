import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class SignupSheet extends StatelessWidget {
  const SignupSheet({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: SignupSheet(),
      route: Navigate.appendRoute("/auth/signup"),
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
              text: "Create your account!",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22),
              weight: FontWeight.bold,
            ),
            TextBuilder(
              text: "An amazing world of possibilities and wonders, waits for your majestic entrance. Please signup to continue.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
            ),
            Spacing.vertical(30),
            BannerAdLayout(
              expandChild: false,
              child: GetX<SignupController>(
                init: SignupController(),
                builder: (controller) {
                  bool showPassword = controller.state.showPassword.value;
                  bool showConfirmPassword = controller.state.showConfirmPassword.value;

                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmartField.builder(
                        formKey: controller.formKey,
                        items: [
                          FieldItem(
                            hint: "Stella Maris",
                            label: "Full Name",
                            controller: controller.fullNameController,
                          ),
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
                          FieldItem(
                            hint: "#@asdaser1232",
                            label: "Confirm Password",
                            isPassword: true,
                            obscureText: showConfirmPassword,
                            onVisibilityTapped: controller.state.showConfirmPassword.toggle,
                            controller: controller.confirmPasswordController,
                            validator: (String? value) {
                              if(value != controller.passwordController.text) {
                                return "Passwords do not match";
                              } else {
                                return null;
                              }
                            },
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
                            validator: metadata.item.validator,
                            obscureText: metadata.item.obscureText,
                            onPressed: metadata.item.onVisibilityTapped,
                            inputDecorationBuilder: (dec) => dec.copyWith(
                              enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                              focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            onTapOutside: (activity) => CommonUtility.unfocus(context),
                            controller: metadata.item.controller,
                          );
                        }
                      ),
                      Spacing.vertical(10),
                      InteractiveButton(
                        text: "Sign up",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.instance.color,
                        textColor: CommonColors.instance.lightTheme,
                        onClick: () => controller.signup(context),
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