import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

import 'widgets/addon_verification.dart';
import 'widgets/loading_addon_verification.dart';

class VerifyTransaction extends StatefulWidget {
  static const String route = "/tx-verify";

  const VerifyTransaction({super.key});

  static Future<T?>? open<T>(String reference) {
    return Navigate.to(
      VerifyTransaction.route,
      parameters: {"reference": reference}
    );
  }

  @override
  State<VerifyTransaction> createState() => _VerifyTransactionState();
}

class _VerifyTransactionState extends State<VerifyTransaction> {
  final ConnectService _connect = Connect();
  bool _isVerifying = true;
  bool _isVerified = false;
  String _error = "Your transaction was not verified, you will be redirected shortly.";
  GoAddonVerification? _verification;

  String _reference = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      _reference = Navigate.parameters["reference"] ?? "";
    });

    _verify();
  }

  void _verify() async {
    setState(() {
      _isVerifying = true;
    });

    Outcome outcome = await _connect.get(endpoint: "/go/addon/see?reference=$_reference");
    if(outcome.isSuccessful) {
      setState(() {
        _verification = GoAddonVerification.fromJson(outcome.data);
      });

      Outcome response = await _connect.get(endpoint: "/go/addon/add?reference=$_reference");

      if(response.isSuccessful) {
        AddonController.data.updateUserAddons(response.data);

        setState(() {
          _isVerifying = false;
          _isVerified = true;
        });
        AddonController.data.fetchOtherAddons();
      } else {
        setState(() {
          _isVerifying = false;
          _isVerified = false;
          _error = "${response.message.capitalizeFirst}. You will be redirected shortly.";
        });
      }

      Future.delayed(Duration(milliseconds: 800), _navigate);
    } else {
      setState(() {
        _isVerifying = false;
        _isVerified = false;
        _error = "${outcome.message.capitalizeFirst}. You will be redirected shortly.";
      });
    }
  }

  void _navigate() {
    if(Navigate.previousRoute.isEmpty) {
      Navigate.all(ParentLayout.route);
    } else {
      Navigate.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Transaction Verifier"),
      child: BannerAdLayout(
        expandChild: true,
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(_isVerifying) ...[
                Loading.vertical(color: Theme.of(context).primaryColor, height: 2),
              ],
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      Assets.logoFavicon,
                      width: 30,
                      height: 30,
                    ),
                    TextBuilder(
                      text: "Nearby, powered by Serchservice Inc.",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(15),
                      weight: FontWeight.bold,
                    ),
                    Spacing.vertical(20),
                  ],
                ),
              ),
              if(_isVerifying) ...[
                LoadingAddonVerification(),
              ] else if(_isVerified) ...[
                Center(
                  child: HeartBeating(
                    child: Icon(
                      Icons.check_circle_sharp,
                      color: CommonColors.instance.success,
                      size: 140,
                    ),
                  )
                ),
                Spacing.vertical(20),
                buttons(),
                Spacing.vertical(20),
                if(_verification.isNotNull) ...[
                  AddonVerification(verification: _verification!)
                ]
              ] else ...[
                Center(
                  child: Icon(
                    Icons.radio_button_checked_rounded,
                    color: CommonColors.instance.error,
                    size: 140,
                  ),
                ),
                Spacing.vertical(5),
                Center(
                  child: TextBuilder.center(
                    text: _error,
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(13),
                  ),
                ),
                Spacing.vertical(20),
                buttons(),
                Spacing.vertical(20),
                if(_verification.isNotNull) ...[
                  AddonVerification(verification: _verification!)
                ]
              ],
              DashedDivider(color: Theme.of(context).primaryColor),
              Center(
                child: TextBuilder.center(
                  text: "With reference: $_reference",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(13),
                ),
              ),
              Center(
                child: TextBuilder.center(
                  text: _isVerifying
                    ? "Please wait while we verify your transaction."
                    : _isVerified
                    ? "Your transaction has been verified."
                    : "Your transaction verification failed.",
                  color: _isVerifying
                    ? Theme.of(context).primaryColor
                    : _isVerified
                    ? CommonColors.instance.green
                    : CommonColors.instance.error,
                  size: Sizing.font(13),
                ),
              )
            ]
          ),
        ),
      )
    );
  }

  Widget buttons() {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextBuilder.center(
          text: "If nothing happens, ",
          color: Theme.of(context).primaryColor,
          size: Sizing.font(13),
        ),
        TextButton(
          onPressed: _navigate,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return CommonColors.instance.bluish.lighten(48);
            }),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
          ),
          child: TextBuilder(
            text: Navigate.previousRoute.isEmpty ? "Go back to home" : "Go back",
            weight: FontWeight.bold,
            color: CommonColors.instance.bluish
          )
        ),
      ]
    );
  }
}