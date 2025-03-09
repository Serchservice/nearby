import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/extensions.dart';
import 'package:smart/ui.dart';

class ActivityCreatingBox extends StatelessWidget {
  final List<GoCreateUpload> uploads;
  final GoCreateUploadReceived onRetried;
  final GoCreateUploadReceived onDismissed;

  const ActivityCreatingBox({
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
      children: uploads.map((GoCreateUpload upload) {
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
                if(upload.create.images.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: CommonColors.instance.lightTheme,
                    ),
                    child: StackedAvatars(
                      avatarSize: 25,
                      avatars: upload.create.images.map((image) => image.path).toList()
                    )
                  )
                ],
                Expanded(
                  child: TextBuilder(
                    text: "${upload.create.emoji} ${upload.create.name}",
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