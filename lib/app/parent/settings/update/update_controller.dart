import 'package:get/get.dart';
import 'package:drive/library.dart';

class UpdateController extends GetxController {
  UpdateController();
  final state = UpdateState();

  List<UpdateLogView> updates = [
    UpdateLogView(
      header: "1.0.2: Enhanced user experience and bug fixes.",
      content: [
        "Changed UI design to facilitate intuitive user experience and faster connection",
        "Improved search functionality for quicker results",
        "Introduced use of in-memory storage for search caching and faster querying",
        "Added support for filtering categories based on location",
        "Resolved bugs causing occasional app crashes",
      ],
      date: "28th November, 2024",
      index: 2,
    ),
    UpdateLogView(
      header: "1.0.1: Introducing dynamic category filters.",
      content: [
        "Implemented dynamic filters for categories",
        "Enhanced UI for better usability",
        "Bug fixes and performance improvements",
      ],
      date: "15th November, 2024",
      index: 1,
    ),
    UpdateLogView(
      header: "0.0.1: Launching Nearby.",
      content: [
        "Select a category of your need",
        "Locate with your current location or search for a location",
        "Show selected result in google map",
      ],
      date: "30th October, 2024",
      index: 0,
    ),
  ];
}