import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class PageNotFoundLayout extends StatelessWidget {
  static const String route = "/page/error/404";
  const PageNotFoundLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      ButtonView(header: "Back to home", icon: Icons.home_rounded, index: 3),
    ];

    void handleClick(ButtonView view) {
      if(view.index.equals(3)) {
        Navigate.all(ParentLayout.route);
      }
    }

    return LayoutWrapper(
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(20)),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logoLogo,
                  width: 70,
                  color: Theme.of(context).primaryColor,
                ),
                Spacer(),
                Image.asset(
                  Assets.logoFavicon,
                  width: 30,
                )
              ]
            ),
            SizedBox(height: 10),
            TextBuilder(
              text: "Page Not Found (404)",
              size: Sizing.font(30),
              weight: FontWeight.w700,
              color: Theme.of(context).primaryColor
            ),
            TextBuilder(
              text: "Oops. We couldn't find the page you were looking for.",
              size: Sizing.font(28),
              weight: FontWeight.w700,
              color: Colors.grey.shade500
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextBuilder(
                      text: "Get back on track",
                      size: Sizing.font(20),
                      color: Theme.of(context).primaryColor
                    ),
                    Spacing.vertical(10),
                    ...buttons.asMap().entries.map((view) {
                      Widget divider() {
                        return Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 1.5,
                          color: Theme.of(context).primaryColor
                        );
                      }

                      return Column(
                        children: [
                          divider(),
                          _buildButton(
                            view: view.value,
                            context: context,
                            onClick: () => handleClick(view.value)
                          ),
                          if(view.key.equals(buttons.length - 1)) ...[
                            divider(),
                          ]
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  Assets.logoInfo,
                  width: 150,
                  color: Theme.of(context).primaryColor
                ),
              ),
            )
          ]
        ),
      )
    );
  }

  Widget _buildButton({required ButtonView view, required VoidCallback onClick, required BuildContext context}) {
    Widget icon(IconData icon) {
      return Icon(
        icon,
        size: 22,
        color: Theme.of(context).primaryColor
      );
    }

    return InkWell(
      onTap: onClick,
      highlightColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon(view.icon),
            Expanded(
              child: TextBuilder(
                text: view.header,
                flow: TextOverflow.ellipsis,
                color: Theme.of(context).primaryColor
              )
            ),
            icon(Icons.arrow_forward_rounded),
          ],
        )
      )
    );
  }
}