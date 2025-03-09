import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/extensions.dart';
import 'package:smart/ui.dart';

class BCapsCreatingBox extends StatelessWidget {
  final List<GoBCapCreateUpload> uploads;
  final GoBCapCreateUploadReceived onRetried;
  final GoBCapCreateUploadReceived onDismissed;

  const BCapsCreatingBox({
    super.key,
    required this.uploads,
    required this.onRetried,
    required this.onDismissed
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: uploads.map((GoBCapCreateUpload upload) {
        BorderRadius borderRadius = BorderRadius.circular(24);

        List<ButtonView> menuItems = [
          ButtonView(onClick: () => onRetried(upload), header: "Retry"),
          ButtonView(onClick: () => onDismissed(upload), header: "Dismiss")
        ];

        return ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            color: CommonColors.instance.color,
            padding: EdgeInsets.all(5),
            child: Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextBuilder(
                    text: upload.create.description.isNotEmpty
                        ? upload.create.description
                        : "Uploading for BCap for Activity #${upload.create.id}...",
                    size: 14,
                    weight: FontWeight.bold,
                    flow: TextOverflow.ellipsis,
                    color: CommonColors.instance.lightTheme,
                  ),
                ),
                if(upload.hasError) ...[
                  MenuAnchor(
                    builder: (BuildContext context, MenuController controller, Widget? child) {
                      return InkWell(
                        onTap: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: CommonColors.instance.error,
                          size: 20
                        ),
                      );
                    },
                    style: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(CommonColors.instance.color.lighten(28)),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    menuChildren: menuItems.map((menu) {
                      return MenuItemButton(
                        onPressed: menu.onClick,
                        child: TextBuilder(
                          text: menu.header,
                          color: CommonColors.instance.color,
                          size: 14,
                          autoSize: false,
                        ),
                      );
                    }).toList(),
                  ),
                ] else ...[
                  Loading.circular(color: CommonColors.instance.lightTheme, width: 2),
                ]
              ]
            ),
          ),
        );
      }).toList(),
    );
  }
}