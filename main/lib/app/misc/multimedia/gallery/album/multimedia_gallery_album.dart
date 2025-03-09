import 'package:drive/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import 'widgets/gallery_album_grid_list_view.dart';
import 'widgets/gallery_album_list_view.dart';

part 'multimedia_gallery_album_state.dart';

class MultimediaGalleryAlbum extends StatefulWidget {
  final Album album;
  final bool multipleAllowed;
  final MediumListReceived onMediumReceived;
  final int? maxSelection;

  const MultimediaGalleryAlbum({
    super.key,
    required this.album,
    required this.maxSelection,
    required this.onMediumReceived,
    required this.multipleAllowed
  });

  @override
  State<MultimediaGalleryAlbum> createState() => _MultimediaGalleryAlbumState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onMediumReceived', onMediumReceived));
    properties.add(DiagnosticsProperty('album', album));
    properties.add(StringProperty('album_id', album.id));
    properties.add(StringProperty('album_name', album.name));
    properties.add(DiagnosticsProperty('album_newest', album.newest));
    properties.add(EnumProperty('album_medium_type', album.mediumType));
    properties.add(IntProperty('album_count', album.count));
    properties.add(StringProperty('album_view', album.toString()));
    properties.add(IntProperty('max_selection', maxSelection));
  }
}