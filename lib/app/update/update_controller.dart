import 'package:get/get.dart';
import 'package:drive/library.dart';

class UpdateController extends GetxController {
  UpdateController();
  final state = UpdateState();

  List<UpdateLogView> updates = [
    UpdateLogView(
      header: "0.0.1: Launching Serch Drive.",
      content: [
        "Select a category of your need.",
        "Locate with your current location or search for a location.",
        "Show selected result in google map.",
      ],
      date: "30th October, 2024",
      index: 0
    )
  ];
}