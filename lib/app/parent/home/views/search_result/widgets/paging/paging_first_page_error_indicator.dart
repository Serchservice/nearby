import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class PagingFirstPageErrorIndicator extends StatelessWidget {
  final String error;
  final VoidCallback onTryAgain;
  final Color? textColor;
  final Color? buttonTextColor;
  final IconData? icon;

  const PagingFirstPageErrorIndicator({
    super.key,
    required this.error,
    required this.onTryAgain,
    this.textColor,
    this.buttonTextColor,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Opacity(
              opacity: 0.2,
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                color: textColor ?? Theme.of(context).primaryColor,
                size: 100
              ),
            ),
            SText.center(
              text: error,
              color: textColor ?? Theme.of(context).primaryColor,
              autoSize: false,
              size: 14
            ),
            SizedBox(height: 30),
            LoadingButton(
              text: "Try again",
              autoSize: false,
              borderRadius: 24,
              onClick: onTryAgain,
              buttonColor: textColor ?? Theme.of(context).primaryColor,
              textColor: buttonTextColor ?? Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            )
          ],
        ),
      ),
    );
  }
}
