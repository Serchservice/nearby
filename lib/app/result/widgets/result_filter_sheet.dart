import 'package:flutter/material.dart';
import 'package:drive/library.dart';

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
      route: "/search/result/filter"
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

  String convertDistance(double meters) {
    if(meters >= 1000) {
      double kilometers = meters / 1000;
      return "${kilometers.toStringAsFixed(2)} km";
    } else {
      return "${meters.toStringAsFixed(2)} m";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
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
            child: SText.center(
              text: "Update your search filter",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 20),
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
                    SText(
                      text: "Maximum Distance",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    ),
                    const Expanded(child: SizedBox()),
                    SText(
                      text: convertDistance(radius),
                      size: Sizing.font(14),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Slider(
                  value: (radius / 100),
                  max: 100,
                  label: radius.round().toString(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: CommonColors.shimmerBase.withOpacity(.48),
                  onChanged: (value) {
                    setState(() {
                      radius = (value * 100);
                    });
                  },
                )
              ],
            )
          ),
          const SizedBox(height: 20),
          SText(
            text: "Filter options",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColor
          ),
          SearchFilter(
            list: widget.list,
            onSelect: (value) => setState(() => selectedIndex = value.index),
            selectedIndex: selectedIndex
          ),
          const SizedBox(height: 30),
          LoadingButton(
            text: "Update",
            borderRadius: 24,
            width: MediaQuery.sizeOf(context).width,
            onClick: () {
              Navigate.back();
              widget.onUpdate.call(
                radius != widget.radius ? radius : null,
                selectedIndex != widget.selectedIndex ? selectedIndex : null
              );
            },
          )
        ],
      )
    );
  }
}