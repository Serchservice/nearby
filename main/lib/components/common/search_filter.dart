import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class SearchFilter extends StatelessWidget {
  final List<ButtonView> list;
  final Function(ButtonView view) onSelect;
  final int selectedIndex;
  final Widget? more;
  const SearchFilter({
    super.key,
    required this.list,
    required this.onSelect,
    required this.selectedIndex,
    this.more
  });

  @override
  Widget build(BuildContext context) {
    if(more != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilters(context),
          const SizedBox(width: 10),
          more!
        ],
      );
    } else {
      return _buildFilters(context);
    }
  }

  Widget _buildFilters(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: list.map((view) {
        final bool isSelected = view.index == selectedIndex;
        return TextButton(
          onPressed: () => onSelect.call(view),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return Database.preference.isLightTheme
                ? isSelected
                ? CommonColors.darkTheme2
                : CommonColors.lightTheme2
                : isSelected
                ? CommonColors.lightTheme2
                : CommonColors.darkTheme2;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return Database.preference.isLightTheme
                ? isSelected
                ? CommonColors.shimmerBase.withValues(alpha: .48)
                : CommonColors.hinted
                : isSelected
                ? CommonColors.hinted
                : CommonColors.shimmerBase.withValues(alpha: .48);
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
              vertical: Sizing.space(4),
              horizontal: Sizing.space(6)
            ))
          ),
          child: SText(
            text: view.header,
            size: Sizing.font(11),
            color: Database.preference.isLightTheme
              ? isSelected
              ? CommonColors.lightTheme
              : CommonColors.darkTheme
              : isSelected
              ? CommonColors.darkTheme
              : CommonColors.lightTheme,
          )
        );
      }).toList(),
    );
  }
}