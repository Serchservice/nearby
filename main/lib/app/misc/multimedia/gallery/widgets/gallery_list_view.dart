import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import '../album/multimedia_gallery_album.dart';

class GalleryListView extends StatelessWidget {
  final List<Album> albums;
  final bool multipleAllowed;
  final MediumListReceived onSelected;
  final int? maxSelection;

  const GalleryListView({
    super.key,
    required this.albums,
    required this.onSelected,
    required this.maxSelection,
    required this.multipleAllowed
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5.0,
      child: ListView.separated(
        padding: EdgeInsets.all(6.0),
        itemCount: albums.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 6);
        },
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
            elevation: 0,
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey[300],
                  height: 70,
                  width: 70,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: AssetImage(AssetUtility.defaultImage),
                    image: AlbumThumbnailProvider(
                      album: album,
                      highQuality: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBuilder(
                        text: (album.name ?? "Unnamed Album").capitalizeEach,
                        size: Sizing.font(14),
                        autoSize: false,
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        flow: TextOverflow.ellipsis,
                      ),
                      TextBuilder(
                        text: "${album.count}",
                        size: Sizing.font(12),
                        autoSize: false,
                        color: Theme.of(context).primaryColor,
                        flow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4, bottom: 2, left: 4, right: 4),
                  decoration: BoxDecoration(
                    color: album.newest ? CommonColors.instance.allDay : CommonColors.instance.shimmer,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4)
                    )
                  ),
                  child: TextBuilder(
                    text: album.newest ? "NEWEST" : "OLDEST",
                    size: 9,
                    autoSize: false,
                    color: CommonColors.instance.lightTheme,
                    flow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }
}
