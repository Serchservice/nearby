import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

import 'widgets/create_activity_button.dart';
import 'widgets/create_activity_image_viewer.dart';
import 'widgets/create_activity_interest_picker.dart';
import 'widgets/create_activity_location_selector.dart';

part 'create_activity_state.dart';

class CreateActivity extends StatefulWidget {
  const CreateActivity({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: CreateActivity(),
      route: Navigate.appendRoute("/create"),
      isScrollable: true
    );
  }

  @override
  State<CreateActivity> createState() => _CreateActivityState();
}