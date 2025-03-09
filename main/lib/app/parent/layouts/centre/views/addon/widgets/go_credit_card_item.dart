import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class GoCreditCardItem extends StatelessWidget {
  final GoCreditCard card;
  const GoCreditCardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: CommonColors.instance.bluish,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextBuilder(
                      text: card.accountName,
                      color: CommonColors.instance.lightTheme,
                      size: 16,
                      weight: FontWeight.bold
                    ),
                  ),
                  Image.asset(
                    Assets.logoFavicon,
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(120)
                },
                children: [
                  if(card.expMonth.isNotEmpty && card.expYear.isNotEmpty) ...[
                    _buildTile(key: "Expiry Date", value: "${card.expMonth}/${card.expYear}"),
                  ],
                  if(card.last4.isNotEmpty) ...[
                    _buildTile(key: "Card Number", value: card.last4),
                  ],
                  if(card.bin.isNotEmpty) ...[
                    _buildTile(key: "Card BIN", value: card.bin),
                  ],
                  if(card.cardType.isNotEmpty) ...[
                    _buildTile(key: "Card Type", value: card.cardType.capitalizeFirst),
                  ],
                  if(card.bank.isNotEmpty) ...[
                    _buildTile(key: "Bank Name", value: card.bank),
                  ],
                  if(card.countryCode.isNotEmpty) ...[
                    _buildTile(key: "Country Code", value: card.countryCode),
                  ],
                ],
              ),
            ),
            Spacing.vertical(20),
            Container(
              padding: const EdgeInsets.all(16),
              color: CommonColors.instance.bluish.lighten(25),
              child: Column(
                spacing: 5,
                children: [
                  Image.asset(
                    Assets.logoInfo,
                    width: double.infinity,
                    height: 12,
                    fit: BoxFit.contain,
                  ),
                  Image.asset(
                    Assets.animGoBeyond,
                    width: double.infinity,
                    height: 12,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            )
          ]
        )
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
            color: CommonColors.instance.lightTheme,
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
            color: color ?? CommonColors.instance.lightTheme,
            size: Sizing.font(13),
          ),
        ),
      ]
    );
  }
}