import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class Field extends StatelessWidget {
  const Field({
    super.key,
    this.inputTextWeight,
    this.controller,
    this.enabled,
    this.focus,
    this.inputAction = TextInputAction.next,
    this.keyboard,
    this.obscureText = false,
    this.validate,
    this.onChanged,
    this.hintText,
    this.textSize = 14,
    this.hintTextWeight,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius,
    this.icon,
    this.onPressed,
    this.iconSize,
    this.isOTP = false,
    this.fillColor,
    this.textColor,
    this.suffixIconConstraints,
    this.noEnabledColor = false,
    this.isBig = false,
    this.needLabel = false,
    this.labelColor,
    this.padding
  });

  Field.password({
    super.key,
    this.hintText,
    this.controller,
    this.enabled,
    this.obscureText = false,
    this.validate,
    this.prefixIcon,
    this.onPressed,
    this.icon,
    this.inputAction = TextInputAction.next,
    this.keyboard,
    this.onChanged,
    this.focus,
    this.textSize = 14,
    this.hintTextWeight,
    this.inputTextWeight,
    this.iconSize,
    this.borderRadius,
    this.isOTP = false,
    this.fillColor,
    this.textColor,
    this.suffixIconConstraints,
    this.noEnabledColor = false,
    this.isBig = false,
    this.needLabel = false,
    this.labelColor,
    this.padding
  }) : suffixIcon = IconButton(
    onPressed: onPressed,
    icon: Icon(
      icon ?? Icons.lock_rounded,
      size: iconSize ?? Sizing.font(24),
    ),
    color: Get.theme.colorScheme.surface
  );

  final FontWeight? inputTextWeight;
  final TextEditingController? controller;
  final bool? enabled;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final FocusNode? focus;
  final TextInputAction inputAction;
  final TextInputType? keyboard;
  final bool obscureText;
  final String? Function(String? p1)? validate;
  final void Function(String p1)? onChanged;
  final String? hintText;
  final double textSize;
  final FontWeight? hintTextWeight;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? borderRadius;
  final bool isOTP;
  final Color? fillColor;
  final Color? textColor;
  final BoxConstraints? suffixIconConstraints;
  final bool noEnabledColor;
  final bool isBig;
  final bool needLabel;
  final Color? labelColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    if(needLabel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: hintText ?? "",
            color: labelColor ?? Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(10)
          ),
          SizedBox(height: Sizing.space(3)),
          _form(context)
        ],
      );
    } else {
      return _form(context);
    }
  }

  Widget _form(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: textColor ?? Theme.of(context).primaryColor,
        fontSize: textSize,
        fontWeight: inputTextWeight
      ),
      textAlign: isOTP ? TextAlign.center : TextAlign.start,
      cursorColor: textColor ?? Theme.of(context).primaryColor,
      // cursorHeight: textSize + 5,
      controller: controller,
      enabled: enabled,
      focusNode: focus,
      maxLines: isBig ? 20 : 1,
      minLines: isBig ? 5 : null,
      textAlignVertical: isBig ? TextAlignVertical.center : null,
      textCapitalization: isBig ? TextCapitalization.sentences : TextCapitalization.none,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: inputAction,
      keyboardType: keyboard,
      obscureText: obscureText,
      validator: validate,
      onChanged: onChanged,
      inputFormatters: [
        if(isOTP)
        LengthLimitingTextInputFormatter(1),
        if(isOTP)
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: isOTP ? EdgeInsets.zero : padding,
        hintStyle: TextStyle(
          color: CommonColors.hint,
          fontSize: textSize,
          fontWeight: hintTextWeight
        ),
        filled: true,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
        prefixIcon: prefixIcon,
        fillColor: fillColor ?? Theme.of(context).scaffoldBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          borderSide: BorderSide(
            width: 2,
            color: noEnabledColor
              ? Theme.of(context).colorScheme.surface
              : textColor ?? Theme.of(context).primaryColor,
            style: BorderStyle.solid,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          borderSide: BorderSide(
            width: 2,
            color: noEnabledColor
              ? Theme.of(context).colorScheme.surface
              : textColor ?? Theme.of(context).primaryColor,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          borderSide: BorderSide(
            width: 2,
            color: textColor ?? Theme.of(context).primaryColor,
            style: BorderStyle.solid,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          borderSide: const BorderSide(
            width: 2,
            color: CommonColors.error,
            style: BorderStyle.solid,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          borderSide: const BorderSide(
            width: 2,
            color: CommonColors.error,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}