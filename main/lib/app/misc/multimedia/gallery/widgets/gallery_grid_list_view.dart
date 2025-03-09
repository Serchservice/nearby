import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

import '../album/multimedia_gallery_album.dart';

class GalleryGridListView extends StatelessWidget {
  final List<Album> albums;
  final bool multipleAllowed;
  final MediumListReceived onSelected;
  final int? maxSelection;

  const GalleryGridListView({
    super.key,
    required this.albums,
    required this.onSelected,
    required this.maxSelection,
    required this.multipleAllowed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int count = 2;
          double gridWidth = (constraints.maxWidth - 20) / count;

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: gridWidth / (gridWidth + 50),
              crossAxisCount: count,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: albums.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Album album = albums[index];

              return Animated(
                toWidget: MultimediaGalleryAlbum(
                  album: album,
                  onMediumReceived: onSelected,
                  multipleAllowed: multipleAllowed,
                  maxSelection: maxSelection
                ),
                borderRadius: BorderRadius.circular(12),
                params: {"id": album.id},
                route: "/gallery/album",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        width: gridWidth,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage(AssetUtility.defaultImage),
                          image: AlbumThumbnailProvider(
                            album: album,
                            highQuality: true,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 4, bottom: 2, left: 4, right: 4),
                            decoration: BoxDecoration(
                              color: album.newest ? CommonColors.instance.allDay : CommonColors.instance.shimmer,
                              borderRadius: BorderRadius.circular(4)
                            ),
                            child: TextBuilder(
                              text: album.newest ? "NEWEST" : "OLDEST",
                              size: 9,
                              autoSize: false,
                              color: CommonColors.instance.lightTheme,
                              flow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextBuilder(
                            text: "(${album.count}) ${(album.name ?? "Unnamed Album").capitalizeEach}",
                            size: 14,
                            autoSize: false,
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            flow: TextOverflow.ellipsis,
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      )
    );
  }
}