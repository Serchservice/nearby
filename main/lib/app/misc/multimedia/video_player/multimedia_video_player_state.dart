part of 'multimedia_video_player.dart';

class _MultimediaVideoPlayerState extends State<MultimediaVideoPlayer> {
  late VideoPlayerController _controller;

  final Color _primaryColor = CommonColors.instance.lightTheme2;

  final Color _backgroundColor = CommonColors.instance.darkTheme2;

  @protected
  double get width => widget.width ?? MediaQuery.of(context).size.width;

  @protected
  double get height => widget.height ?? (widget._isScreen ? MediaQuery.of(context).size.height : 200);

  @protected
  bool get showControl => widget.showControl;

  @protected
  bool get autoPlay => widget.autoPlay;

  @protected
  bool get isScreen => widget._isScreen;

  late String _videoPath;

  bool _isInitialized = false;

  bool _isFailed = false;

  bool _isBuffering = false;

  bool _isDarkMode = Database.instance.isDarkTheme;

  @override
  void initState() {
    setState(() {
      _videoPath = widget.video;
    });

    _initializeDependencies();

    super.initState();
  }

  void _initializeDependencies() async {
    if(_videoPath.isNotEmpty) {
      if(_videoPath.isURL) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(_videoPath));
      } else if(_videoPath.isLocalFile) {
        _controller = VideoPlayerController.file(File(_videoPath));
      } else {
        _controller = VideoPlayerController.asset(_videoPath);
      }

      _controller.addListener(_startListening);
      _loop();

      try {
        await _controller.initialize();

        if(mounted) {
          setState(() {
            _isInitialized = true;
          });
        }

        if(autoPlay) {
          await _controller.play();
        }
      } on PlatformException {
        if(mounted) {
          setState(() {
            _isFailed = true;
          });
        }
      } catch(e) {
        console.log(e);
      }
    }
  }

  void _startListening() {
    if(mounted) {
      setState(() {
        _isBuffering = _controller.value.isBuffering;
      });
    }
  }

  void _loop() async {
    if(isScreen.isFalse || widget.loopContinuously) {
      await _controller.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(covariant MultimediaVideoPlayer oldWidget) {
    if(oldWidget.video.notEquals(widget.video)) {
      if(mounted) {
        setState(() {
          _videoPath = widget.video;
        });

        _initializeDependencies();
      }
    }

    if(oldWidget.isDarkMode.notEquals(widget.isDarkMode)) {
      _isDarkMode = widget.isDarkMode;
    }

    if(oldWidget.loopContinuously.notEquals(widget.loopContinuously)) {
      _loop();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _initializeDependencies();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.removeListener(_startListening);
    _controller.dispose();

    super.dispose();
  }

  @protected
  Widget failed() {
    return Container(
      height: height,
      width: width,
      color: isScreen ? _backgroundColor : null,
      decoration: isScreen ? null : BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _backgroundColor
      ),
      child: Center(
        child: TextBuilder(
          text: "Failed to load video",
          color: _primaryColor,
          weight: FontWeight.bold,
        )
      )
    );
  }

  @protected
  Widget main() => VideoPlayer(_controller);

  @protected
  double get videoHeight => _controller.value.size.height;

  @protected
  double get videoWidth => _controller.value.size.width;

  @protected
  Widget progressIndicator() {
    return VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
      colors: VideoProgressColors(
        playedColor: CommonColors.instance.color,
        bufferedColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: _backgroundColor,
      )
    );
  }

  @protected
  Widget screen() {
    Widget child = Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        main(),
        if(_isBuffering) ...[
          buffering()
        ] else ...[
          callback(),
        ],
        if(showControl) ...[
          _ControlsOverlay(controller: _controller)
        ],
        progressIndicator(),
      ],
    );

    console.log("Use Size: ${widget.useSize}");

    if(widget.useSize) {
      return Container(
        height: videoHeight,
        width: videoWidth,
        color: _backgroundColor,
        child: child,
      );
    } else {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: child,
      );
    }
  }

  @protected
  Widget buffering() => Align(
    alignment: Alignment.center,
    child: Loading.circular(color: _primaryColor, size: 50)
  );

  @protected
  Widget callback() {
    Widget child() {
      if(_controller.value.isPlaying) {
        return Center(child: SizedBox.shrink());
      } else {
        return ColoredBox(
          color: Colors.black26,
          child: Center(
            child: Icon(
              Icons.play_arrow,
              color: _primaryColor,
              size: 60.0,
              semanticLabel: 'Play',
            ),
          ),
        );
      }
    }

    return InkWell(
      onTap: _controller.value.isPlaying ? _controller.pause : _controller.play,
      child: Align(
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: child(),
        )
      ),
    );
  }

  @protected
  Widget box() {
    Widget control = Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        main(),
        if(_isBuffering) ...[
          buffering()
        ] else ...[
          callback(),
        ],
        _ControlsOverlay(controller: _controller),
        progressIndicator()
      ],
    );

    return SizedBox(
      height: height,
      width: width,
      child: showControl ? control : main(),
    );
  }

  @protected
  Widget loading() {
    return LoadingShimmer(
      isDarkMode: _isDarkMode,
      content: Container(
        height: height,
        width: width,
        color: isScreen ? CommonColors.instance.shimmerHigh : null,
        decoration: isScreen ? null : BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CommonColors.instance.shimmerHigh
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_isFailed) {
      return failed();
    } else if(_isInitialized) {
      if(isScreen) {
        return screen();
      } else {
        return box();
      }
    } else {
      return loading();
    }
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}