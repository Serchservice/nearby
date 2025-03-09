import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class AppInformationSheet extends StatelessWidget {
  final List<ButtonView> options;
  final String? header;
  final Function(ButtonView) onTap;

  const AppInformationSheet({
    super.key,
    required this.options,
    required this.onTap,
    this.header
  });
  
  static void open({required List<ButtonView> options, String? header, required Function(ButtonView) onTap}) => {
    Navigate.bottomSheet(
      sheet: AppInformationSheet(options: options, onTap: onTap, header: header),
      route: Navigate.appendRoute(header != null ? "/options?for=${header.toLowerCase()}" : "/options")
    )
  };

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      sheetPadding: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
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
          if(header != null && header!.isNotEmpty) ...[
            Center(
              child: TextBuilder(
                text: header!,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(18),
                weight: FontWeight.bold,
              ),
            ),
            Spacing.vertical(15),
          ],
          ...options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap.call(option),
                  child: Padding(
                    padding: EdgeInsets.all(Sizing.space(10)),
                    child: Row(
                      children: [
                        Icon(
                          option.icon,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(25)
                        ),
                        Spacing.horizontal(10),
                        Expanded(
                          child: TextBuilder(
                            text: option.header,
                            size: 14,
                            color: Theme.of(context).primaryColor
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              )
            );
          })
        ],
      )
    );
  }
}