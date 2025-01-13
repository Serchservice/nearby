import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionConsentWrapper extends StatefulWidget {
  final Widget child;

  const PermissionConsentWrapper({super.key, required this.child});

  @override
  State<PermissionConsentWrapper> createState() => _PermissionConsentWrapperState();
}

class _PermissionConsentWrapperState extends State<PermissionConsentWrapper> {
  final PermissionConsentController _consentController = PermissionConsentController();

  @override
  void initState() {
    _consentController.init();
    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    _consentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: widget.child,
        ),
        StreamBuilder<PermissionConsent>(
          stream: _consentController.consentStream,
          builder: (_, snapshot) {
            double width = 440;
            bool resize = MediaQuery.sizeOf(context).width <= width;
            PermissionConsent? consent = snapshot.data;

            if(consent != null && consent.show) {
              return Positioned(
                bottom: 10,
                right: resize ? 6 : 16,
                left: resize ? 6 : null,
                child: _buildConsentCard(_consentController, resize, width),
              );
            }

            return SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget _buildConsentCard(PermissionConsentController controller, bool resize, double width) {
    return SizedBox(
      width: resize ? MediaQuery.sizeOf(context).width : width,
      child: Card(
        elevation: 4,
        color: Get.theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: AssetUtility.image(Assets.mapWorld),
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              SText(
                text: "In order to give you a smooth user experience, Nearby requires some basic permissions to be granted.",
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 10),
              SText(
                text: "Some required permissions include:",
                size: Sizing.font(12),
                color: Theme.of(context).primaryColor,
              ),
              ...["Location", "and others"].map((item) {
                return SText(
                  text: "* $item",
                  size: Sizing.font(12),
                  color: Theme.of(context).primaryColor,
                );
              }),
              if(PlatformEngine.instance.isWeb) ...[
                const SizedBox(height: 10),
                SText(
                  text: "**NOTE** Permissions might take longer time in web before they show up or might even require you to click on `Grant` for them to show.",
                  size: Sizing.font(12),
                  color: Theme.of(context).primaryColor,
                )
              ],
              const SizedBox(height: 20),
              Center(
                child: LoadingButton(
                  text: "Grant permissions",
                  borderRadius: 24,
                  width: MediaQuery.sizeOf(context).width,
                  textSize: Sizing.font(14),
                  buttonColor: CommonColors.darkTheme2,
                  textColor: CommonColors.lightTheme,
                  onClick: () => controller.grant(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}