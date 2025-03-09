part of 'multimedia_gallery.dart';

class _MultimediaGalleryState extends State<MultimediaGallery> {
  final AccessService _accessService = AccessImplementation();

  /// All albums
  List<Album> _albums = <Album>[];

  bool _isGrid = true;

  @override
  void initState() {
    initializeGallery();

    super.initState();
  }

  void initializeGallery() async {
    if(await _accessService.checkForStorageOrAskPermission(PlatformEngine.instance.device.sdk)) {
      List<Album> list = [];

      if(widget.showOnlyVideo) {
        list = await Gallery.listAlbums(mediumType: MediumType.video);
      } else if(widget.showOnlyPhoto) {
        list = await Gallery.listAlbums(mediumType: MediumType.image);
      } else {
        list = await Gallery.listAlbums();
      }

      setState(() {
        _albums = list;
      });
    }
  }

  void handleSelectedListMedia(List<SelectedMedia> files) {
    if(widget.onMediaReceived.isNotNull) {
      widget.onMediaReceived!(files);
    }
  }

  Future<void> handleMedium(List<Medium> medium) async {
    if(widget.onMediaReceived.isNotNull) {
      List<Future<SelectedMedia>> list = medium.map((medium) async {
        final file = await medium.getFile();
        MediaType type = medium.mediumType.isNotNull
          ? (medium.mediumType == MediumType.video ? MediaType.video : MediaType.photo)
          : (file.path.isVideo ? MediaType.video : MediaType.photo);

        return SelectedMedia(
          path: file.path,
          size: (await file.length()).toFileSize,
          media: type,
          data: await file.readAsBytes(),
        );
      }).toList();

      List<SelectedMedia> files = [];
      for(Future<SelectedMedia> file in list) {
        files.add(await file);
      }

      widget.onMediaReceived!(files);
      Navigate.back(result: files);
    }
  }

  @protected
  String get header => widget.showOnlyVideo ? "Video" : widget.showOnlyPhoto ? "Photo" : "Media";

  @protected
  bool get multipleAllowed => widget.allowMultipleSelection;

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      theme: Database.instance.theme,
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      appbar: AppBar(
        elevation: 0.5,
        title: TextBuilder.center(
          text: widget.title,
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          InfoButton(
            onPressed: () => setState(() {
              _isGrid = !_isGrid;
            }),
            icon: Icon(
              _isGrid ? Icons.grid_view_rounded : Icons.format_list_bulleted_outlined,
              color: Theme.of(context).primaryColor
            ),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmartButton(
            tab: ButtonView(
              icon: Icons.photo_library_rounded,
              header: "Select from file manager",
              body: "You can select up to 30mb of photo size",
            ),
            onTap: () => AssetUtility.pickFromFile(
              onError: (error, tip) {
                notify.tip(message: error);
              },
              handleSelected: handleSelectedListMedia,
              onlyVideo: widget.showOnlyVideo,
              onlyPhoto: widget.showOnlyPhoto,
              multipleAllowed: multipleAllowed,
              title: widget.title
            ),
          ),
          Divider(color: Theme.of(context).primaryColor),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: TextBuilder(
              text: "Gallery $header Albums",
              color: Theme.of(context).primaryColorLight,
              size: Sizing.font(14),
            ),
          ),
          Divider(color: Theme.of(context).primaryColor),
          Expanded(child: _build())
        ],
      )
    );
  }

  Widget _build() {
    if(_albums.isEmpty) {
      return Container();
    } else if(_isGrid) {
      return GalleryGridListView(
        albums: _albums,
        multipleAllowed: multipleAllowed,
        onSelected: handleMedium,
        maxSelection: widget.maxSelection,
      );
    } else {
      return GalleryListView(
        albums: _albums,
        multipleAllowed: multipleAllowed,
        onSelected: handleMedium,
        maxSelection: widget.maxSelection,
      );
    }
  }
}