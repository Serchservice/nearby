import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class Multimedia<T> extends StatelessWidget {
  final SelectedMediaListReceived? onListReceived;
  final SelectedMediaReceived? onReceived;
  final String route;
  final bool onlyVideo;
  final bool onlyPhoto;
  final String title;
  final bool allowMultiple;

  const Multimedia({
    super.key,
    this.onListReceived,
    this.onReceived,
    required this.route,
    required this.onlyVideo,
    required this.onlyPhoto,
    required this.title,
    required this.allowMultiple
  });

  static Future<T?> open<T>({
    SelectedMediaReceived? onReceived,
    SelectedMediaListReceived? onListReceived,
    required String route,
    bool onlyVideo = false,
    String title = "Pick your avatar",
    bool onlyPhoto = false,
    bool allowMultiple = true
  }) async {
    if(PlatformEngine.instance.isMobile) {
      return Navigate.bottomSheet(
        sheet: Multimedia(
          onReceived: onReceived,
          onListReceived: onListReceived,
          route: route,
          onlyPhoto: onlyPhoto,
          title: title,
          onlyVideo: onlyVideo,
          allowMultiple: allowMultiple
        ),
        isScrollable: true,
        route: Navigate.appendRoute(route)
      );
    } else {
      List<SelectedMedia> files = await AssetUtility.pickFromFile();
      if(onListReceived.isNotNull) {
        onListReceived!(files);
      }

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> options = [
      ButtonView(
        icon: Icons.photo_library_rounded,
        header: "Gallery",
        index: 0,
        color: Theme.of(context).primaryColor
      ),
      ButtonView(
        index: 1,
        icon: Icons.photo_camera_back_rounded,
        header: "Camera",
        color: Theme.of(context).primaryColor
      )
    ];

    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      sheetPadding: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: [
                  ModalBottomSheetIndicator(
                    showButton: false,
                    color: CommonColors.instance.darkTheme2,
                    backgroundColor: CommonColors.instance.lightTheme2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBuilder(
                                text: "Select your media preference",
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                              TextBuilder(
                                text: "Pick option for media upload",
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColorLight,
                                flow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Icon(Icons.directions, size: 40, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                runSpacing: 20,
                children: options.map((option) {
                  return SmartButton.selective(
                    tab: option,
                    selectiveWidth: 70,
                    onTap: () async {
                      T? result;
                      if(option.index.equals(0)) {
                        result = await MultimediaGallery.to(
                          allowMultipleSelection: allowMultiple,
                          onlyPhoto: onlyPhoto,
                          onlyVideo: onlyVideo,
                          title: title
                        );
                      } else {
                        result = await MultimediaCamera.to(onlyPhoto: onlyPhoto, onlyVideo: onlyVideo, info: title);
                      }

                      if(result.isNotNull && result.instanceOf<SelectedMedia>()) {
                        if(onReceived.isNotNull) {
                          onReceived!(result! as SelectedMedia);
                        }
                      } else if(result.isNotNull && result.instanceOf<List<SelectedMedia>>()) {
                        if(onListReceived.isNotNull) {
                          onListReceived!(result! as List<SelectedMedia>);
                        }
                      }
                    },
                  );
                }).toList(),
              ),
            )
          ],
        ),
      )
    );
  }
}