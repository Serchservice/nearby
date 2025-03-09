import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

part 'multimedia_image_viewer_state.dart';

class MultimediaImageViewer extends StatefulWidget {
  final SelectedMedia media;

  const MultimediaImageViewer({super.key, required this.media});

  @override
  State<MultimediaImageViewer> createState() => _MultimediaImageViewerState();
}