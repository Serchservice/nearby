part of 'multimedia_gallery_album.dart';

class _MultimediaGalleryAlbumState extends State<MultimediaGalleryAlbum> {
  bool _isGrid = true;

  List<Medium> _mediums = <Medium>[];

  List<Medium> _selected = [];

  int _gridCount = 2;

  int _filter = 0;

  bool _isFetching = true;

  @override
  void initState() {
    _fetch();

    super.initState();
  }

  void _fetch() async {
    MediaPage page = await widget.album.listMedia();
    setState(() {
      _mediums = page.items;
      _isFetching = false;
    });
  }

  @override
  void didUpdateWidget(covariant MultimediaGalleryAlbum oldWidget) {
    if(oldWidget.album.notEquals(widget.album) || oldWidget.multipleAllowed.notEquals(widget.multipleAllowed)) {
      setState(() { });
    }

    super.didUpdateWidget(oldWidget);
  }

  List<ButtonView> filters = [
    ButtonView(header: "2x", index: 0),
    ButtonView(header: "3x", index: 1),
  ];

  void onGridCountChanged(int value) {
    int grid = _gridCount;
    if(value.equals(0)) {
      grid = 2;
    } else if(value == 1) {
      grid = 3;
    }

    setState(() {
      _gridCount = grid;
      _filter = value;
    });
  }

  void _update(Medium medium) {
    if(multipleAllowed) {
      List<Medium> list = List.from(_selected);
      int index = list.findIndex((i) => i.id.equals(medium.id));
      if(index.equals(-1)) {
        list.add(medium);
      } else {
        list.removeAt(index);
      }

      setState(() {
        _selected = list;
      });
    } else {
      widget.onMediumReceived([medium]);
    }
  }

  @protected
  bool get multipleAllowed => widget.multipleAllowed;

  @protected
  List<String> get selectedIds => _selected.map((m) => m.id).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      theme: Database.instance.theme,
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      appbar: AppBar(
        elevation: 0.5,
        title: TextBuilder.center(
          text: ("${widget.album.name ?? "Unnamed Album"} (${widget.album.count.toString()})").capitalizeEach,
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          if(selectedIds.isNotEmpty) ...[
            TextButton(
              onPressed: () => widget.onMediumReceived(_selected),
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  return CommonColors.instance.bluish.lighten(48);
                }),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
              ),
              child: TextBuilder(
                text: "Done",
                weight: FontWeight.bold,
                color: CommonColors.instance.bluish
              )
            ),
          ],
          InfoButton(
            onPressed: () => setState(() => _isGrid = !_isGrid),
            icon: Icon(
              _isGrid ? Icons.grid_view_rounded : Icons.format_list_bulleted_outlined,
              color: Theme.of(context).primaryColor
            ),
          )
        ],
      ),
      child: _build()
    );
  }

  Widget _build() {
    if(_isFetching) {
      return Center(child: Loading.circular(color: Theme.of(context).primaryColor));
    } else if(_mediums.isEmpty) {
      return Container();
    } else if(_isGrid) {
      return Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchFilter.short(
              list: filters,
              selectedIndex: _filter,
              onSelect: (view) => onGridCountChanged(view.index),
            ),
          ),
          Expanded(
            child: GalleryAlbumGridListView(
              mediums: _mediums,
              onSelected: _update,
              count: _gridCount,
              selected: selectedIds
            )
          )
        ]
      );
    } else {
      return GalleryAlbumListView(
        mediums: _mediums,
        onSelected: _update,
        selected: selectedIds
      );
    }
  }
}