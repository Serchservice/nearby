part of 'go_bcap_creator.dart';

class _GoBCapCreatorState extends State<GoBCapCreator> {
  final TextEditingController _textController = TextEditingController();

  List<SelectedMedia> _files = [];

  @override
  void didUpdateWidget(covariant GoBCapCreator oldWidget) {
    if(oldWidget.activity != widget.activity) {
      setState(() {
        _files = [];
        _currentMedia = null;
      });

    }
    super.didUpdateWidget(oldWidget);
  }

  @protected
  void onImageClicked<T>() async {
    T? result = await Multimedia.open(
      route: "/media_experience",
      onlyPhoto: false,
      onlyVideo: false,
      allowMultiple: true,
      onListReceived: _updateMediaWithList,
      onReceived: _updateMediaWithSingle
    );

    if(result.instanceOf<List<SelectedMedia>>()) {
      _updateMediaWithList(result as List<SelectedMedia>);
    } else if(result.instanceOf<SelectedMedia>()) {
      _updateMediaWithSingle(result as SelectedMedia);
    }
  }

  void _updateMediaWithList(List<SelectedMedia> items) {
    setState(() {
      _files = [..._files, ...items];
    });
  }

  void _updateMediaWithSingle(SelectedMedia item) {
    setState(() {
      _files = [..._files, item];
    });
  }

  SelectedMedia? _currentMedia;

  @protected
  Widget get fileListView => Row(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SmartButton.selective(
        tab: ButtonView(icon: Icons.add, header: "Add", index: 0, color: CommonColors.instance.color),
        selectiveWidth: 80,
        backgroundColor: CommonColors.instance.color.lighten(30),
        onTap: onImageClicked,
      ),
      if(_files.isNotEmpty) ...[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _files.map((SelectedMedia file) {
                bool isActive = file.path.equals(_currentMedia?.path ?? "");

                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Material(
                      color: Colors.transparent,
                      shape: isActive ? RoundedRectangleBorder(
                        side: BorderSide(color: CommonColors.instance.color, width: 2),
                        borderRadius: BorderRadius.circular(6)
                      ) : null,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentMedia = file;
                          });
                        },
                        child: file.media.isPhoto ? Image(
                          image: AssetUtility.image(file.path),
                          fit: BoxFit.cover,
                        ) : MultimediaVideoPlayer.box(
                          video: file.path,
                          width: 80,
                          height: 80,
                          autoPlay: false,
                          showControl: false
                        )
                      ),
                    )
                  ),
                );
              }).toList(),
            )
          ),
        )
      ],
    ]
  );

  @protected
  Widget get currentView {
    if(_currentMedia.isNotNull && _currentMedia!.media.isPhoto) {
      return Image(
        image: AssetUtility.image(_currentMedia!.path),
        fit: BoxFit.cover,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
      );
    } else if(_currentMedia.isNotNull && _currentMedia!.media.isVideo) {
      return MultimediaVideoPlayer.box(
        video: _currentMedia!.path,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        showControl: false,
        autoPlay: true,
      );
    } else {
      return Container();
    }
  }

  @protected
  Widget get floatingView => Positioned(
    bottom: 6,
    left: 6,
    right: 6,
    child: Material(
      color: Colors.transparent,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - 20,
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            fileListView,
            Field(
              hint: "Describe your experience (Optional)",
              replaceHintWithLabel: false,
              minLines: 1,
              enabled: true,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.sentences,
              modeValidator: AutovalidateMode.onUserInteraction,
              keyboard: TextInputType.multiline,
              inputConfigBuilder: (config) => config.copyWith(
                labelColor: Theme.of(context).primaryColor,
                labelSize: 14
              ),
              borderRadius: 24,
              inputDecorationBuilder: (dec) => dec.copyWith(
                enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              onTapOutside: (activity) => CommonUtility.unfocus(context),
              controller: _textController,
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Row(
                spacing: 30,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: activity.name,
                          size: Sizing.font(14),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          flow: TextOverflow.ellipsis
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: activity.colored.lighten(40),
                          ),
                          child: TextBuilder(
                            text: activity.status,
                            autoSize: false,
                            size: 11,
                            color: activity.colored,
                            weight: FontWeight.bold,
                            flow: TextOverflow.ellipsis
                          )
                        )
                      ],
                    ),
                  ),
                  TextBuilder(
                    text: activity.interest?.emoji ?? "",
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    flow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: CommonColors.instance.bluish,
                borderRadius: BorderRadius.circular(12)
              ),
              child: TextBuilder(
                text: "Do not upload any video or image above 100mb.",
                size: 12,
                color: CommonColors.instance.lightTheme
              )
            ),
          ]
        ),
      ),
    )
  );

  @protected
  Widget get header => Row(
    children: [
      GoBack(
        onTap: () => Navigate.close(closeAll: false),
        color: CommonColors.instance.bluish,
      ),
      TextBuilder(
        text: "Share your experience",
        size: Sizing.font(18),
        weight: FontWeight.bold,
        color: CommonColors.instance.bluish
      ),
      Spacing.flexible(),
      if(canCreate) ...[
        TextButton.icon(
          onPressed: _create,
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(48)),
            backgroundColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(24)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
          ),
          icon: _isCreating
              ? Loading.circular(color: CommonColors.instance.bluish, width: 2)
              : Icon(Icons.check, color: CommonColors.instance.bluish),
          label: TextBuilder(
            text: "Create",
            weight: FontWeight.bold,
            color: CommonColors.instance.bluish
          )
        ),
      ],
    ],
  );

  @protected
  GoActivity get activity => widget.activity;

  @protected
  bool get canCreate => _files.isNotEmpty;

  bool _isCreating = false;

  void _create() async {
    if(canCreate) {
      setState(() => _isCreating = true);

      GoBCapCreate create = GoBCapCreate(
        id: activity.id,
        media: _files,
        description: _textController.text
      );

      CentreLifeCycle.onGoBCapCreate(create);
      setState(() => _isCreating = false);
      Navigator.pop(context);
    } else {
      notify.tip(message: "Please add media files to continue", color: CommonColors.instance.bluish);
    }
  }

  @override
  void dispose() {
    _currentMedia = null;
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      borderRadius: BorderRadius.zero,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.zero,
      child: BannerAdLayout(
        mainAxisSize: MainAxisSize.min,
        child: Stack(
          children: [
            currentView,
            floatingView,
            Positioned(
              top: 4,
              left: 4,
              right: 4,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: header
              )
            ),
          ],
        ),
      ),
    );
  }
}