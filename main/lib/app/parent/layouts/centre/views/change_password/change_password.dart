import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: ChangePassword(),
      route: Navigate.appendRoute("/change_password"),
      isScrollable: true
    );
  }

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  final ConnectService _connect = Connect();

  bool _isSaving = false;
  bool _showPassword = true;
  bool _showOldPassword = true;
  bool _showConfirmPassword = true;

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleOldPassword() {
    setState(() {
      _showOldPassword = !_showOldPassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void _change() {
    CommonUtility.unfocus(context);

    if(_newPasswordController.text.notEquals(_confirmNewPasswordController.text)) {
      notify.warn(message: "Password does not match");
      return;
    }

    if(formKey.currentState.isNotNull && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      JsonMap payload = {
        "old_password": _oldPasswordController.text.trim(),
        "new_password": _newPasswordController.text.trim(),
      };

      setState(() {
        _isSaving = true;
      });

      _connect.post(endpoint: "/auth/go/change_password", body: payload).then((Outcome response) {
        setState(() {
          _isSaving = false;
        });

        if (response.isSuccessful) {
          notify.success(message: "Password changed successfully");
          GoAuthResponse auth = GoAuthResponse.fromJson(response.data);

          ActivityLifeCycle.onAuthenticated(auth);
          BCapLifeCycle.onAuthenticated(auth);
        } else {
          notify.error(message: response.message);
        }
      });
    }
  }

  @override
  void dispose() {
    _confirmNewPasswordController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();

    super.dispose();
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
        child: BannerAdLayout(
          expandChild: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(2)),
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
              ),
              Spacing.vertical(20),
              TextBuilder(
                text: "Change my password!",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(16),
                weight: FontWeight.bold,
              ),
              TextBuilder(
                text: "Let's setup a new pair of authentication keys.",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14),
              ),
              Spacing.vertical(30),
              SmartField.builder(
                formKey: formKey,
                validateMode: AutovalidateMode.disabled,
                items: [
                  FieldItem(
                    hint: "#@asdaser1232",
                    label: "Old Password",
                    isPassword: true,
                    controller: _oldPasswordController,
                    obscureText: _showOldPassword,
                    onVisibilityTapped: _toggleOldPassword,
                  ),
                  FieldItem(
                    hint: "#@asdaser1232",
                    label: "New Password",
                    isPassword: true,
                    controller: _newPasswordController,
                    validator: InputValidator.password,
                    obscureText: _showPassword,
                    onVisibilityTapped: _togglePassword,
                  ),
                  FieldItem(
                    hint: "#@asdaser1232",
                    label: "Confirm New Password",
                    isPassword: true,
                    controller: _confirmNewPasswordController,
                    obscureText: _showConfirmPassword,
                    onVisibilityTapped: _toggleConfirmPassword,
                    validator: (String? value) {
                      if(value != _newPasswordController.text) {
                        return "Password does not match";
                      }

                      return null;
                    },
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
                    validator: metadata.item.validator,
                    obscureText: metadata.item.obscureText,
                    onPressed: metadata.item.onVisibilityTapped,
                    fillColor: Theme.of(context).appBarTheme.backgroundColor,
                    onTapOutside: (activity) => CommonUtility.unfocus(context),
                    controller: metadata.item.controller,
                  );
                }
              ),
              Spacing.vertical(20),
              InteractiveButton(
                text: "Change password",
                borderRadius: 24,
                width: MediaQuery.sizeOf(context).width,
                textSize: Sizing.font(14),
                buttonColor: CommonColors.instance.color,
                textColor: CommonColors.instance.lightTheme,
                onClick: _change,
                loading: _isSaving,
              ),
            ],
          ),
        ),
      )
    );
  }
}