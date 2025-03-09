import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class ResultFilterSheet extends StatefulWidget {
  final double radius;
  final List<ButtonView> list;
  final Function(double? range, int? index) onUpdate;
  final int selectedIndex;

  const ResultFilterSheet({
    super.key,
    required this.radius,
    required this.list,
    required this.onUpdate,
    required this.selectedIndex
  });

  static void open({
    required double radius,
    required List<ButtonView> list,
    required Function(double? range, int? index) onUpdate,
    required int selectedIndex,
  }) => Navigate.bottomSheet(
    sheet: ResultFilterSheet(radius: radius, list: list, onUpdate: onUpdate, selectedIndex: selectedIndex),
    isScrollable: true,
    safeArea: false,
    route: Navigate.appendRoute("/result/filter")
  );

  @override
  State<ResultFilterSheet> createState() => _ResultFilterSheetState();
}

class _ResultFilterSheetState extends State<ResultFilterSheet> {
  late int selectedIndex;
  late double radius;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    radius = widget.radius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              alignment: Alignment.center,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          Center(
            child: TextBuilder.center(
              text: "Update your search filter",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          Spacing.vertical(20),
          Container(
            padding: EdgeInsets.all(Sizing.space(12)),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.surface,
                  offset: const Offset(4, -2),
                  blurRadius: 10,
                  blurStyle: BlurStyle.normal
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextBuilder(
                      text: "Maximum Distance",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    ),
                    Spacing.flexible(),
                    TextBuilder(
                      text: radius.distance,
                      size: Sizing.font(14),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                ),
                Spacing.vertical(20),
                Slider(
                  value: (radius / 100),
                  max: 100,
                  label: radius.round().toString(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: CommonColors.instance.shimmerBase.withAlpha(48),
                  onChanged: (value) {
                    setState(() {
                      radius = (value * 100);
                    });
                  },
                )
              ],
            )
          ),
          Spacing.vertical(20),
          TextBuilder(
            text: "Filter options",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColor
          ),
          SearchFilter(
            list: widget.list,
            onSelect: (value) => setState(() => selectedIndex = value.index),
            selectedIndex: selectedIndex
          ),
          Spacing.vertical(30),
          InteractiveButton(
            text: "Update",
            borderRadius: 24,
            width: MediaQuery.sizeOf(context).width,
            onClick: () {
              Navigate.back();
              widget.onUpdate(
                radius.equals(widget.radius) ? null : radius,
                selectedIndex.equals(widget.selectedIndex) ? null : selectedIndex
              );
            },
          )
        ],
      )
    );
  }
}