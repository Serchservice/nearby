import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetView, Obx;
import 'package:smart/smart.dart';

import 'controllers/account_update_controller.dart';

class AccountUpdateLayout extends GetView<AccountUpdateController> {
  static String get route => "/account/update";

  const AccountUpdateLayout({super.key});

  static void to() => Navigate.to(route);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double value = controller.state.searchRadius.value / controller.maxRadius;

      return LayoutWrapper(
        layoutKey: Key("Account Update"),
        appbar: AppBar(
          title: TextBuilder(
            text: "Account Update",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(22),
            weight: FontWeight.bold,
          ),
        ),
        child: SingleChildScrollView(
          child: BannerAdLayout(
            expandChild: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.vertical(10),
                  Center(
                    child: Column(
                      spacing: 12,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.changeAvatar,
                              child: Avatar(avatar: controller.state.avatar.value, radius: 100)
                            )
                          )
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: TextBuilder(
                            text: "Tap on the picture to change avatar.",
                            size: Sizing.font(12),
                            color: Theme.of(context).primaryColor
                          ),
                        )
                      ],
                    ),
                  ),
                  SmartField.builder(
                    formKey: controller.formKey,
                    items: [
                      FieldItem(
                        hint: "Stella",
                        label: "First Name",
                        controller: controller.firstNameController,
                        validator: InputValidator.text
                      ),
                      FieldItem(
                        hint: "Maris",
                        label: "Last Name",
                        controller: controller.lastNameController,
                        validator: InputValidator.text
                      ),
                      FieldItem(
                        hint: "+2349128129212",
                        label: "Contact",
                        controller: controller.contactController,
                        validator: (value) {
                          if(value.isNotNull && (!value!.isEmail || !value.isPhoneNumber)) {
                            return "Invalid contact";
                          } else {
                            return null;
                          }
                        }
                      ),
                    ],
                    itemBuilder: (context, field, metadata) {
                      return field.copyWith(
                        hint: metadata.item.hint,
                        needLabel: true,
                        replaceHintWithLabel: false,
                        label: metadata.item.label,
                        inputConfigBuilder: (config) => config.copyWith(
                          labelColor: Theme.of(context).primaryColor,
                          labelSize: 14
                        ),
                        inputDecorationBuilder: (dec) => dec.copyWith(
                          enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                          focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onTapOutside: (activity) => CommonUtility.unfocus(context),
                        controller: metadata.item.controller,
                      );
                    }
                  ),
                  Spacing.vertical(20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextBuilder(
                        text: "Maximum Distance",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor
                      ),
                      Spacing.flexible(),
                      TextBuilder(
                        text: controller.state.searchRadius.value.distance,
                        size: Sizing.font(14),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    ],
                  ),
                  Spacing.vertical(20),
                  Slider(
                    value: value,
                    max: controller.maxRadius,
                    label: controller.state.searchRadius.value.round().toString(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: CommonColors.instance.shimmerBase.withAlpha(48),
                    onChanged: controller.changeSearchRadius,
                  ),
                  Spacing.vertical(20),
                  if(controller.showButton) ...[
                    InteractiveButton(
                      text: "Update account",
                      borderRadius: 24,
                      width: MediaQuery.sizeOf(context).width,
                      textSize: Sizing.font(14),
                      buttonColor: CommonColors.instance.color,
                      textColor: CommonColors.instance.lightTheme,
                      onClick: controller.save,
                      loading: controller.state.isSaving.value,
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
