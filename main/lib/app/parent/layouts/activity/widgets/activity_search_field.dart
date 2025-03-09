import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class ActivitySearchField extends StatelessWidget {
  final TextEditingController searchController;
  final bool hideSearchButton;
  final VoidCallback onClosed;
  final Animation<double> animation;
  final Color buttonColor;
  final Color buttonIconColor;

  const ActivitySearchField({
    super.key,
    required this.searchController,
    required this.hideSearchButton,
    required this.onClosed,
    required this.animation,
    required this.buttonColor,
    required this.buttonIconColor
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil responsive = ResponsiveUtil(context);

    if(hideSearchButton.isFalse) {
      return InfoButton(
        icon: Icon(Icons.manage_search_rounded, color: buttonColor,),
        backgroundColor: WidgetStateProperty.all(buttonIconColor),
        onPressed: onClosed,
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - (responsive.isDesktop ? 100 : 20),
          child: SizeTransition(
            sizeFactor: animation,
            child: Field(
              hint: "Hi ${Database.instance.auth.firstName}, how can I be of help?",
              replaceHintWithLabel: false,
              inputConfigBuilder: (config) => config.copyWith(
                labelColor: Theme.of(context).primaryColor,
                labelSize: 14
              ),
              borderRadius: 24,
              prefixIcon: Icon(Icons.search_rounded, size: 30, color: buttonColor),
              suffixIcon: InfoButton(
                onPressed: () {
                  CommonUtility.unfocus(context);
                  onClosed();
                },
                icon: Icon(Icons.cancel, size: 30, color: buttonColor),
              ),
              inputDecorationBuilder: (dec) => dec.copyWith(
                enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                focusedBorderSide: BorderSide(color: CommonColors.instance.bluish),
              ),
              controller: searchController,
            ),
          ),
        ),
      );
    }
  }
}