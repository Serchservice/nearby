import 'package:drive/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import 'widgets/gallery_grid_list_view.dart';
import 'widgets/gallery_list_view.dart';

part 'multimedia_gallery_state.dart';

class MultimediaGallery extends StatefulWidget {
  final String title;
  final bool showOnlyVideo;
  final bool showOnlyPhoto;
  final bool allowMultipleSelection;
  final OnInformationReceived? onInfoReceived;
  final OnErrorReceived? onErrorReceived;
  final SelectedMediaListReceived? onMediaReceived;
  final VoidCallback? onClosed;
  final VoidCallback onGoingBack;
  final Widget? backButton;
  final int? maxSelection;

  const MultimediaGallery({
    super.key,
    this.title = "",
    this.showOnlyVideo = false,
    this.showOnlyPhoto = true,
    this.onErrorReceived,
    this.onMediaReceived,
    this.onClosed,
    this.onInfoReceived,
    required this.onGoingBack,
    this.backButton,
    this.allowMultipleSelection = false,
    this.maxSelection
  });

  static String route = "/gallery";

  static Future<T?>? to<T>({
    bool allowMultipleSelection = false,
    String title = "Pick your avatar",
    bool onlyVideo = false,
    bool onlyPhoto = true,
    int? maxSelection
  }) {
    return Navigate.toPage(
      widget: MultimediaGallery(
        showOnlyVideo: onlyVideo,
        showOnlyPhoto: onlyPhoto,
        allowMultipleSelection: allowMultipleSelection,
        onMediaReceived: (media) {
          console.log(media);
        },
        maxSelection: maxSelection,
        onGoingBack: () => Navigate.back(),
        onErrorReceived: (error, tip) => notify.tip(message: error, color: CommonColors.instance.error),
        onInfoReceived: (title) => notify.tip(message: title, color: CommonColors.instance.shimmer),
      ),
      route: route
    );
  }

  @override
  State<MultimediaGallery> createState() => _MultimediaGalleryState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onMediaReceived', onMediaReceived));
    properties.add(DiagnosticsProperty('onGoingBack', onGoingBack));
    properties.add(DiagnosticsProperty('onErrorReceived', onErrorReceived));
    properties.add(DiagnosticsProperty('onInfoReceived', onInfoReceived));
    properties.add(DiagnosticsProperty('onClosed', onClosed));
    properties.add(DiagnosticsProperty('allowMultipleSelection', allowMultipleSelection));
    properties.add(DiagnosticsProperty('maxSelection', maxSelection));
  }
}