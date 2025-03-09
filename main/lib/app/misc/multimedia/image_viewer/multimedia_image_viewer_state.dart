part of 'multimedia_image_viewer.dart';

class _MultimediaImageViewerState extends State<MultimediaImageViewer> {
  PaletteGenerator? _palette;

  @protected
  String get image => widget.media.path;

  @protected
  ImageProvider<Object> get imageProvider => AssetUtility.image(image);

  @protected
  Color get backgroundColor => _palette.isNull || (_palette.isNotNull && _palette!.dominantColor.isNull)
      ? CommonColors.instance.darkTheme2
      : _palette!.dominantColor!.color;

  @protected
  Color get primaryColor => backgroundColor.isWhiteRange() ? CommonColors.instance.darkTheme2 : CommonColors.instance.lightTheme2;

  @protected
  Brightness get brightness => backgroundColor.isWhiteRange() ? Brightness.dark : Brightness.light;

  @override
  void initState() {
    _initializeDependencies();

    super.initState();
  }

  Future<void> _initializeDependencies() async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);

    setState(() {
      _palette = paletteGenerator;
    });
  }

  @override
  void didUpdateWidget(covariant MultimediaImageViewer oldWidget) {
    if(oldWidget.media.path.notEquals(widget.media.path) || oldWidget.media.notEquals(widget.media)) {
      _initializeDependencies();

      setState(() {

      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @protected
  String get title => widget.media.path.getFileName();

  @protected
  String get size => widget.media.size;

  @protected
  String get location => widget.media.path.isURL ? "Web" : widget.media.path.isLocalFile ? "Phone Storage" : "App-defined asset";

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      theme: Database.instance.theme,
      config: UiConfig(
        systemNavigationBarColor: backgroundColor,
        statusBarColor: backgroundColor,
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
      ),
      backgroundColor: backgroundColor,
      extendBehindAppbar: true,
      floaterPosition: 0,
      floater: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(title.isNotEmpty) ...[
                  TextBuilder(
                    text: title,
                    size: Sizing.font(14),
                    color: primaryColor
                  ),
                ],
                if(size.isNotEmpty) ...[
                  TextBuilder(
                    text: size,
                    size: Sizing.font(12),
                    color: primaryColor
                  ),
                ],
                if(location.isNotEmpty) ...[
                  TextBuilder(
                    text: "Location: $location",
                    size: Sizing.font(9),
                    color: primaryColor,
                    flow: TextOverflow.ellipsis,
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
      child: Stack(
        children: [
          Image(
            image: AssetUtility.image(image),
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
          ),
          Positioned(
            top: 6,
            left: 6,
            child: GoBack(
              icon: Icons.arrow_back,
              color: primaryColor,
            )
          )
        ],
      ),
    );
  }
}