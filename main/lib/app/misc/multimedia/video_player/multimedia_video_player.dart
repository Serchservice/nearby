import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart/smart.dart';
import 'package:universal_io/io.dart';
import 'package:video_player/video_player.dart';

part 'multimedia_video_player_state.dart';

class MultimediaVideoPlayer extends StatefulWidget {
  final String video;
  final bool _isScreen;
  final double? width;
  final double? height;
  final bool autoPlay;
  final bool showControl;
  final bool isDarkMode;
  final bool useSize;
  final bool loopContinuously;

  const MultimediaVideoPlayer.screen({
    super.key,
    required this.video,
    this.width,
    this.height,
    this.autoPlay = true,
    this.showControl = true,
    this.isDarkMode = false,
    this.loopContinuously = false,
    this.useSize = true,
  }) : _isScreen = true;

  const MultimediaVideoPlayer.box({
    super.key,
    required this.video,
    this.width,
    this.height,
    this.autoPlay = true,
    this.showControl = true,
    this.isDarkMode = false,
    this.loopContinuously = false,
    this.useSize = true,
  }) : _isScreen = false;

  @override
  State<MultimediaVideoPlayer> createState() => _MultimediaVideoPlayerState();
}