import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class PreferenceSwitcher extends StatelessWidget {
  final ButtonView view;
  final VoidCallback? onTap;
  final Widget? more;
  final Function(bool value) onChange;
  final bool value;

  const PreferenceSwitcher({
    super.key,
    required this.view,
    required this.onChange,
    required this.value,
    this.onTap,
    this.more
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 30,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(text: view.header, size: Sizing.font(14), color: Theme.of(context).primaryColor),
              SText(text: view.body, size: Sizing.font(12), color: Theme.of(context).primaryColorLight),
              if(more != null) ...[ more! ]
            ],
          )
        ),
        Switcher(onChanged: onChange.call, value: value)
      ],
    );
  }
}