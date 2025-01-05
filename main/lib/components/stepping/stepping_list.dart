import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class SteppingList extends StatelessWidget {
  final List<Stepping> steppings;
  const SteppingList({super.key, required this.steppings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: steppings.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        bool showLine = index != steppings.length - 1;
        final stepping = steppings[index];

        return Stepping(
          content: stepping.content,
          lineColor: stepping.lineColor,
          step: stepping.step,
          showLine: showLine,
          showStepCircle: stepping.showStepCircle,
          icon: stepping.icon,
          iconSize: stepping.iconSize,
          padding: stepping.padding
        );
      }
    );
  }
}