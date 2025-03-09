import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class Switcher extends StatelessWidget {
  const Switcher({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final Function(bool val) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (value) {
          return CommonColors.instance.green;
        } else {
          return Colors.green.withValues(alpha: .48);
        }
      }),
      // trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((Set<WidgetState> states) {
      //   if (value) {
      //     return 22.0;
      //   } else {
      //     return 15.0; // Use the default width.
      //   }
      // }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if(Database.instance.isLightTheme) {
          return CommonColors.instance.lightTheme2;
        } else {
          return CommonColors.instance.darkTheme2;
        }
      }),
      thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (value) {
          return CommonColors.instance.success;
        } else {
          return Theme.of(context).primaryColor;
        }
      }),
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (value) {
          return Icon(Icons.check, size: Sizing.space(15));
        } else {
          return const Icon(Icons.check);
        }
      }),
    );
  }
}