import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

part 'go_bcap_creator_state.dart';

class GoBCapCreator extends StatefulWidget {
  final GoActivity activity;
  const GoBCapCreator({super.key, required this.activity});

  static void open(GoActivity activity) {
    Navigate.bottomSheet(
      sheet: GoBCapCreator(activity: activity),
      route: Navigate.appendRoute("/bcap-create?for=${activity.id}"),
      isScrollable: true
    );
  }

  @override
  State<GoBCapCreator> createState() => _GoBCapCreatorState();
}