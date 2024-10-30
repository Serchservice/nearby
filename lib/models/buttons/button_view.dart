import 'package:flutter/material.dart';
import 'package:drive/library.dart';

/// This class will be used for views like:
///
/// [TalkButton] For buttons that will comprise of call, chat, etc,
/// [AppBarOptions] For app bar in user individual chats,
/// [DRAWER] For Home Drawer
/// [AccountPicker] for picking accounts
///
/// Filter buttons and Service Picking
/// [FilterButton] For applying filters to the search page
/// Class for service button on the home screen and request sharing [ServiceList]
///
/// This model will help in showing views for items like:
///
/// Showing rundowns and share button
/// For share in referrals [REFERRAL]
/// For rundown details [RUNDOWN]
///
/// For keyboards
class ButtonView {
  /// Compulsory Icon
  final IconData icon;

  /// Compulsory Index
  final int index;

  // Optional header
  final String header;

  /// Body of the item
  final String body;

  /// Optional double
  final double number;

  /// Color of the icon
  final Color color;

  /// Screen as the path
  final String path;

  /// Function callback
  final VoidCallback? onClick;

  final List<String> description;

  final String asset;

  ButtonView({
    this.icon = Icons.copy,
    this.index = 0,
    this.header = "",
    this.body = "",
    this.number = 0.0,
    this.color = CommonColors.lightTheme,
    this.path = "/",
    this.onClick,
    this.description = const [],
    this.asset = ""
  });
}