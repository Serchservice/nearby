import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class FakeField extends StatelessWidget {
  const FakeField({
    super.key,
    required this.buttonText,
    required this.searchText,
    this.onTap,
    this.showSearch = true,
    this.needPadding = true,
    this.color
  });

  final String buttonText;
  final String searchText;
  final bool needPadding;
  final VoidCallback? onTap;
  final Color? color;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: needPadding
        ? const EdgeInsets.symmetric(horizontal: 12.0)
        : EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: color ?? Theme.of(context).appBarTheme.backgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.only(left: 16.0),
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Expanded(
                    child: SText(
                      text: searchText,
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  if(showSearch) ...[
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16)
                        ),
                        color: Theme.of(context).primaryColor
                      ),
                      child: SText(
                        text: buttonText,
                        size: Sizing.font(14),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                    )
                  ] else ...[
                    Container(padding: const EdgeInsets.all(26.0),)
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}