import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class CreateActivityImageViewer extends StatelessWidget {
  final List<SelectedMedia> files;
  final SelectedMediaReceived onDeleted ;

  const CreateActivityImageViewer({super.key, required this.files, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    Widget deleter(SelectedMedia media, Widget child) {
      return Badge(
        backgroundColor: CommonColors.instance.error,
        padding: EdgeInsets.zero,
        label: InkWell(
          onTap: () => onDeleted(media),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.close, color: CommonColors.instance.lightTheme, size: 12),
          )
        ),
        child: child
      );
    }

    double height = 200;

    if(files.isLengthEqualTo(1)) {
      SelectedMedia media = files.first;
      Widget child = Image(
        image: AssetUtility.image(media.path),
        height: height,
      );

      return deleter(media, child);
    } else {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10, right: 10),
          separatorBuilder: (context, index) {
            return Spacing.horizontal(10);
          },
          itemBuilder: (context, index) {
            SelectedMedia media = files[index];

            Widget child = SizedBox(
              width: height - 10,
              child: Animated(
                toWidget: MultimediaImageViewer(media: media),
                borderRadius: BorderRadius.circular(12),
                params: {"id": media.hashCode},
                route: Navigate.appendRoute("/view_photo"),
                child: Image(
                  image: AssetUtility.image(media.path),
                  fit: BoxFit.cover,
                )
              ),
            );

            return deleter(media, child);
          }
        )
      );
    }
  }
}
