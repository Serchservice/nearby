import 'package:flutter/material.dart' show Icons;
import 'package:get/get.dart';
import 'package:smart/smart.dart' show ButtonView;
import 'package:drive/library.dart';

import 'account_centre_state.dart';

class AccountCentreController extends GetxController {
  AccountCentreController();
  final state = AccountCentreState();

  List<ButtonView> tabs = [
    ButtonView(
      header: "Addons",
      body: "Enhance your experience with addons",
      index: 0,
      icon: Icons.extension_rounded,
      color: Get.theme.primaryColor,
      onClick: AddonLayout.to
    ),
    ButtonView(
      header: "Update my account",
      body: "Update your account information",
      index: 1,
      icon: Icons.account_circle_rounded,
      color: Get.theme.primaryColor,
      onClick: AccountUpdateLayout.to
    ),
    ButtonView(
      header: "Change password",
      body: "Guard your account with a secure password",
      index: 2,
      icon: Icons.password_rounded,
      color: Get.theme.primaryColor,
      onClick: ChangePassword.open
    ),
    ButtonView(
      header: "Go Interests",
      body: "Manage your interests, explore your world.",
      index: 3,
      icon: Icons.interests_rounded,
      color: Get.theme.primaryColor,
      onClick: GoInterestLayout.to
    ),
    ButtonView(
      header: "Go Activities",
      body: "View your go-activity history, manage your activities.",
      index: 4,
      icon: Icons.dynamic_feed_rounded,
      color: Get.theme.primaryColor,
      onClick: GoActivityLayout.to
    ),
    // ButtonView(header: "Go Calendar",
    //   index: 5,
    //   icon: Icons.calendar_month_rounded,
    // ),
    // ButtonView(header: "Go Settings",
    //   index: 6,
    //   icon: Icons.settings
    // ),
    // ButtonView(header: "Go Clubs",
    //   index: 7,
    //   icon: Icons.class_rounded,
    // ),
    // ButtonView(header: "Go Communities",
    //   index: 8,
    //   icon: Icons.group_rounded,
    // ),
    ButtonView(
      header: "Sign out",
      index: 9,
      icon: Icons.logout_rounded,
      color: CommonColors.instance.error,
      onClick: SignOut.open
    )
  ];
}