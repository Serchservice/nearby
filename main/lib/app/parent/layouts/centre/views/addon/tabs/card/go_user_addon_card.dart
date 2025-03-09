import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

import 'go_user_addon_card_sheet.dart';

class GoUserAddonCard extends StatefulWidget {
  final GoUserAddon addon;
  final GoUserAddonUpdated onUpdated;

  const GoUserAddonCard({super.key, required this.addon, required this.onUpdated});

  @override
  State<GoUserAddonCard> createState() => _GoUserAddonCardState();
}

class _GoUserAddonCardState extends State<GoUserAddonCard> {
  late GoUserAddon _addon;

  @override
  void initState() {
    setState(() {
      _addon = widget.addon;
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant GoUserAddonCard oldWidget) {
    if(oldWidget.addon != widget.addon) {
      setState(() {
        _addon = widget.addon;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  void onUpdated(GoUserAddon addon) {
    setState(() {
      _addon = addon;
    });

    widget.onUpdated(addon);
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _addon.status.equalsIgnoreCase("active")
      ? CommonColors.instance.green
      : _addon.status.equalsIgnoreCase("renewal_due")
      ? CommonColors.instance.premium
      : _addon.status.equalsIgnoreCase("cancelled")
      ? CommonColors.instance.warning
      : CommonColors.instance.error;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () => GoUserAddonCardSheet.open(_addon, onUpdated),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: CommonColors.instance.color)
          ),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CommonColors.instance.color.lighten(33),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.extension_outlined,
                      color: CommonColors.instance.color,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: _addon.name,
                          size: 15,
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2, left: 4, right: 4),
                          decoration: BoxDecoration(
                            color: statusColor.lighten(45),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextBuilder(
                            text: _addon.status.replaceAll("_", " "),
                            size: 11,
                            weight: FontWeight.bold,
                            autoSize: false,
                            color: statusColor
                          )
                        )
                      ]
                    ),
                  ),
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextBuilder(
                        text: _addon.amount,
                        size: 14,
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                      TextBuilder(
                        text: _addon.interval.replaceAll("_", " "),
                        size: 9,
                        autoSize: false,
                        color: CommonColors.instance.bluish
                      )
                    ],
                  )
                ],
              ),
              TextBuilder(
                text: _addon.description,
                size: 12,
                color: Theme.of(context).primaryColorLight,
              ),
              if(_addon.recurring) ...[
                Container(
                  padding: EdgeInsets.only(top: 2, left: 4, right: 4, bottom: 2),
                  decoration: BoxDecoration(
                    color: statusColor.lighten(55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextBuilder(
                    text: "Recurring payment",
                    size: 12,
                    weight: FontWeight.bold,
                    autoSize: false,
                    color: statusColor
                  )
                )
              ],
              if(_addon.switching.isNotNull) ...[
                Container(
                  padding: EdgeInsets.only(top: 2, left: 4, right: 4, bottom: 2),
                  decoration: BoxDecoration(
                    color: CommonColors.instance.warning.lighten(55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextBuilder(
                    text: "You have a pending switch to another plan",
                    size: 12,
                    weight: FontWeight.bold,
                    autoSize: false,
                    color: CommonColors.instance.warning
                  )
                )
              ],
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(120)
                },
                children: [
                  if(_addon.timeline.subscribedAt.isNotEmpty) ...[
                    _buildTile(key: "Subscription Date", value: _addon.timeline.subscribedAt),
                  ],
                  if(_addon.timeline.nextBillingDate.isNotEmpty) ...[
                    _buildTile(key: "Next Billing Date", value: _addon.timeline.nextBillingDate),
                  ],
                ],
              ),
            ]
          )
        ),
      ),
    );
  }

  TableRow _buildTile({required String key, required String value, Color? color}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: TextBuilder(
            autoSize: false,
            text: key,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(12),
            weight: FontWeight.bold
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: TextBuilder(
            autoSize: false,
            text: value,
            weight: color != null ? FontWeight.bold : FontWeight.normal,
            color: color ?? Theme.of(context).primaryColor,
            size: Sizing.font(13),
          ),
        ),
      ]
    );
  }
}