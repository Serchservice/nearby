import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class GalleryAlbumListView extends StatelessWidget {
  final List<Medium> mediums;
  final List<String> selected;
  final MediumReceived onSelected;

  const GalleryAlbumListView({
    super.key,
    required this.mediums,
    required this.onSelected,
    required this.selected
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5.0,
      child: ListView.separated(
        padding: EdgeInsets.all(6.0),
        itemCount: mediums.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 6);
        },
        itemBuilder: (context, index) {
          Medium medium = mediums[index];
          IconData icon = medium.mediumType == MediumType.video
              ? Icons.slow_motion_video_rounded
              : medium.mediumType == MediumType.image
              ? Icons.motion_photos_on_rounded
              : Icons.browse_gallery_rounded;
          bool isSelected = selected.any((i) => i.equals(medium.id));
          int selectedIndex = selected.findIndex((i) => i.equals(medium.id));
          Color color = isSelected.isFalse ? Colors.teal : CommonColors.instance.green;

          return SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Material(
                shape: isSelected ? RoundedRectangleBorder(
                  side: BorderSide(color: color, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ) : null,
                child: InkWell(
                  onTap: () => onSelected(medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          width: MediaQuery.sizeOf(context).width,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height,
                                width: MediaQuery.sizeOf(context).width,
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder: AssetImage(AssetUtility.defaultImage),
                                  image: ThumbnailProvider(
                                    mediumId: medium.id,
                                    mediumType: medium.mediumType,
                                    highQuality: true,
                                  ),
                                ),
                              ),
                              if(isSelected) ...[
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Badge(
                                    backgroundColor: color,
                                    textColor: CommonColors.instance.lightTheme,
                                    label: TextBuilder(
                                      text: "${selectedIndex.plus(1)}",
                                      size: Sizing.font(14),
                                      autoSize: false,
                                    ),
                                  )
                                )
                              ],
                            ],
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBuilder(
                              text: (medium.filename ?? medium.title ?? "Unnamed image").capitalizeEach,
                              size: Sizing.font(14),
                              autoSize: false,
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              flow: TextOverflow.ellipsis,
                            ),
                            Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextBuilder(
                                    text: (medium.size ?? 0).toFileSize,
                                    size: Sizing.font(12),
                                    autoSize: false,
                                    color: Theme.of(context).primaryColor,
                                    flow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(icon, size: 20, color: color)
                              ],
                            ),
                          ],
                        ),
                      )
                    ]
                  ),
                ),
              ),
            )
          );
        }
      )
    );
  }
}
