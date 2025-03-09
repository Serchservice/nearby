import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class SearchFilter<T> extends StatelessWidget {
  final List<ButtonView> list;
  final Function(ButtonView view) onSelect;
  final int selectedIndex;
  final List<T> selectedList;
  final Widget? more;
  final Color? color;
  final double? textSize;
  final double? spacing;
  final double? runSpacing;

  final Size? _size;

  const SearchFilter({
    super.key,
    required this.list,
    required this.onSelect,
    this.selectedIndex = - 1,
    this.selectedList = const [],
    this.more,
    this.textSize,
    this.color,
    this.spacing,
    this.runSpacing,
    Size? size,
  }) : _size = size;

  const SearchFilter.short({
    super.key,
    required this.list,
    required this.onSelect,
    this.selectedIndex = - 1,
    this.selectedList = const [],
    this.more,
    this.color,
    this.textSize,
    this.spacing,
    this.runSpacing,
  }) : _size = const Size(35, 25);

  @override
  Widget build(BuildContext context) {
    if(more.isNotNull) {
      return Row(
        spacing: 10,
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
      spacing: spacing ?? 5,
      runSpacing: runSpacing ?? 5,
      children: list.map((view) {
        Object checker = T is String ? view.header : view.index;
        final bool isSelected = view.index.equals(selectedIndex) || selectedList.contains(checker);

        final Color baseColor = color ?? CommonColors.instance.bluish;
        final Color bgColor = isSelected ? baseColor.lighten(45) : baseColor.lighten(90);
        final Color txtColor = isSelected ? baseColor : baseColor.lighten(30);

        return TextButton(
          onPressed: () => onSelect(view),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) => bgColor),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return baseColor.lighten(60);
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: _size.isNotNull ? WidgetStateProperty.resolveWith((state) => _size) : null,
          ),
          child: TextBuilder(
            text: view.header,
            size: Sizing.font(textSize ?? 11),
            color: txtColor,
          )
        );
      }).toList(),
    );
  }
}