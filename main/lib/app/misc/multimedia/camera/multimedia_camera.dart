import 'dart:async';

import 'package:camera/camera.dart';
import 'package:drive/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

import 'restorable_camera_controller.dart';

part 'multimedia_camera_state.dart';

class MultimediaCamera extends StatefulWidget {
  final String info;
  final bool showOnlyVideo;
  final bool showOnlyPhoto;
  final bool isWeb;
  final List<CameraDescription> cameras;
  final OnErrorReceived? onErrorReceived;
  final OnInformationReceived? onInfoReceived;
  final SelectedMediaReceived? onRecordingCompleted;
  final SelectedMediaReceived? onImageTaken;
  final CameraDescriptionUpdated? cameraDescriptionUpdated;
  final VoidCallback onGoingBack;
  final Widget? backButton;
  final double? floatingPosition;

  const MultimediaCamera({
    super.key,
    this.info = "",
    this.isWeb = false,
    this.showOnlyVideo = false,
    this.showOnlyPhoto = true,
    this.onErrorReceived,
    this.cameras = const [],
    this.cameraDescriptionUpdated,
    this.onRecordingCompleted,
    this.onImageTaken,
    this.onInfoReceived,
    required this.onGoingBack,
    this.backButton,
    this.floatingPosition
  });

  static const String route = "/camera";

  static Future<T?>? to<T>({String info = "", bool onlyVideo = false, bool onlyPhoto = true}) {
    return Navigate.toPage(
      widget: MultimediaCamera(
        isWeb: PlatformEngine.instance.isWeb,
        showOnlyVideo: onlyVideo,
        showOnlyPhoto: onlyPhoto,
        cameras: MainConfiguration.data.cameras,
        cameraDescriptionUpdated: (cameras) => MainConfiguration.data.cameras.value = cameras,
        onRecordingCompleted: (media) {},
        // onImageTaken: (media) {
        //   Navigate.back(result: media);
        // },
        onGoingBack: () => Navigate.back(),
        onErrorReceived: (error, tip) => notify.tip(message: error, color: CommonColors.instance.error),
        onInfoReceived: (info) => notify.tip(message: info, color: CommonColors.instance.shimmer),
      ),
      route: route
    );
  }

  @override
  State<MultimediaCamera> createState() => _MultimediaCameraState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onImageTaken', onImageTaken));
    properties.add(DiagnosticsProperty('onRecordingCompleted', onRecordingCompleted));
    properties.add(DiagnosticsProperty('onGoingBack', onGoingBack));
    properties.add(DiagnosticsProperty('cameraDescriptionUpdated', cameraDescriptionUpdated));
    properties.add(DiagnosticsProperty('onErrorReceived', onErrorReceived));
    properties.add(DiagnosticsProperty('onInfoReceived', onInfoReceived));
    properties.add(DiagnosticsProperty('cameras', cameras));
    properties.add(DiagnosticsProperty('isWeb', isWeb));
  }
}