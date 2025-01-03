import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class SearchResultItemButton extends StatelessWidget {
  final ButtonView option;
  final VoidCallback? onTap;

  const SearchResultItemButton({super.key, required this.option, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(option.icon, color: Theme.of(context).primaryColorDark, size: 18),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText.center(
                            text: option.header,
                            autoSize: false,
                            color: Theme.of(context).primaryColor,
                            size: Sizing.font(12),
                            flow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}