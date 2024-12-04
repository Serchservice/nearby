import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class AppInformationSection extends StatelessWidget {
  const AppInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: "App Information",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: [
                  ButtonView(
                    header: "Visit Serchservice",
                    index: 0,
                    icon: Icons.web_rounded,
                    path: Constants.baseWeb
                  ),
                  ButtonView(
                    header: "Acknowledgement",
                    index: 1,
                    icon: Icons.book_outlined,
                  ),
                  ButtonView(
                    header: "Legal",
                    index: 2,
                    icon: Icons.rule_rounded
                  )
                ].map((view) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if(view.index == 0) {
                          RouteNavigator.openWeb(header: "Serchservice", url: view.path);
                        } else if(view.index == 1) {
                          showLicensePage(
                              context: context,
                            applicationName: ParentController.data.state.appName.value,
                            applicationVersion: ParentController.data.state.appVersion.value,
                            applicationLegalese: "Your nearby search, refined"
                          );
                        } else {
                          ParentController.data.openLegal();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(view.icon, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 10),
                            SText(
                              text: view.header,
                              size: Sizing.font(14),
                              color: Theme.of(context).primaryColor
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}