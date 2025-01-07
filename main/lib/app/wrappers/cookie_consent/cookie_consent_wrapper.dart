import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CookieConsentWrapper extends StatefulWidget {
  final Widget child;

  const CookieConsentWrapper({super.key, required this.child});

  @override
  State<CookieConsentWrapper> createState() => _CookieConsentWrapperState();
}

class _CookieConsentWrapperState extends State<CookieConsentWrapper> {
  final CookieConsentController _consentController = CookieConsentController();

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
        StreamBuilder<bool>(
          stream: _consentController.showConsentStream,
          builder: (_, snapshot) {
            bool showConsent = snapshot.data ?? false;
            double width = 540;
            bool resize = MediaQuery.sizeOf(context).width <= width;

            if(showConsent) {
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

  Widget _buildConsentCard(CookieConsentController controller, bool resize, double width) {
    return SizedBox(
      width: resize ? MediaQuery.sizeOf(context).width : width,
      child: Card(
        elevation: 4,
        color: Get.theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(text: "We use cookies", size: 24, weight: FontWeight.w900, color: Get.theme.primaryColor),
              StreamBuilder<bool>(
                stream: controller.settingsStream,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    bool showSettings = snapshot.data ?? false;

                    if(showSettings) {
                      return Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.views().map((tab) {
                          return StreamBuilder<Cookie>(
                            stream: controller.cookieStream,
                            builder: (_, snap) {
                              Cookie cookie = snap.data ?? controller.cookie;

                              return _buildSelector(context, tab, controller.isSelected(tab.index, cookie));
                            }
                          );
                        }).toList(),
                      );
                    }
                  }

                  return Column(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: [
                          "Click “Accept” to enable Serchservice to use cookies to personalize this site, and to deliver ads",
                          "and measure their effectiveness on other apps and websites, including social media. Customize your",
                          "preferences in your Cookie Settings or click “Reject” if you do not want us to use cookies for",
                          "this purpose."
                        ].join(" "),
                        size: 12,
                        weight: FontWeight.w500,
                        color: Get.theme.primaryColor
                      ),
                      InkWell(
                        onTap: controller.visitCookiePolicy,
                        child: SText(
                          text: "See our cookie policy",
                          size: 12,
                          weight: FontWeight.bold,
                          color: Get.theme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  );
                }
              ),
              SizedBox(height: 10),
              Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<bool>(
                    stream: controller.settingsStream,
                    builder: (context, snapshot) {
                      bool showSettings = snapshot.data ?? false;

                      return LoadingButton(
                        padding: EdgeInsets.all(Sizing.space(6)),
                        text: showSettings ? "Hide" : "Cookie Settings",
                        textColor: Theme.of(context).primaryColor,
                        buttonColor: Colors.transparent,
                        borderRadius: 8,
                        textSize: 12,
                        autoSize: false,
                        textWeight: FontWeight.bold,
                        onClick: controller.toggle,
                      );
                    }
                  ),
                  LoadingButton(
                    padding: EdgeInsets.all(Sizing.space(6)),
                    text: "Reject",
                    textColor: Theme.of(context).primaryColor,
                    buttonColor: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: 8,
                    textSize: 12,
                    autoSize: false,
                    textWeight: FontWeight.bold,
                    onClick: controller.reject,
                  ),
                  LoadingButton(
                    padding: EdgeInsets.all(Sizing.space(6)),
                    text: "Accept",
                    textColor: Theme.of(context).scaffoldBackgroundColor,
                    buttonColor: Theme.of(context).primaryColor,
                    borderRadius: 8,
                    textSize: 12,
                    autoSize: false,
                    textWeight: FontWeight.bold,
                    onClick: controller.accept,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelector(BuildContext context, ButtonView tab, bool isSelected) {
    Color textColor = isSelected ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        child: InkWell(
          onTap: tab.onClick,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(text: tab.header, size: 14, weight: FontWeight.bold, color: textColor),
                SText(text: tab.body, color: CommonColors.hint, size: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}