import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:smart/smart.dart' show StringExtensions, DynamicExtensions, IterableExtension, MediaType, IntExtensions;
import 'package:universal_io/io.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class AssetUtility {
  static ImageProvider image(String image, {String? fallback}) {
    if(image.isURL) {
      return CachedNetworkImageProvider(
        image,
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorListener: (obj) => AssetImage(fallback ?? Assets.logoFavicon),
      );
    } else if(image.isLocalFile) {
      return FileImage(File(image));
    } else if(image.isMemoryImage) {
      return MemoryImage(base64Decode(image.split(",").last));
    } else if(image.isNotEmpty) {
      return AssetImage(image);
    } else {
      return AssetImage(AssetUtility.defaultImage);
    }
  }

  static String get defaultImage => Database.instance.isDarkTheme
    ? Assets.commonDriveCarBlack
    : Assets.commonDriveCarWhite;
  
  static Future<List<SelectedMedia>> pickFromFile({
    OnErrorReceived? onError,
    bool onlyVideo = false,
    bool onlyPhoto = true,
    String title = "",
    SelectedMediaListReceived? handleSelected,
    bool multipleAllowed = false
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: onlyVideo ? FileType.video : onlyPhoto ? FileType.image : FileType.media,
        allowMultiple: multipleAllowed,
        dialogTitle: title
      );

      if(result.isNotNull && result!.files.isNotEmpty) {
        if(result.files.all((file) => (file.path ?? file.name).isImage || (file.path ?? file.name).isVideo)) {
          List<SelectedMedia> files = result.files.map((file) {
            String path = file.path ?? file.name;

            return SelectedMedia(
              path: path,
              data: file.bytes,
              size: file.size.toFileSize,
              media: path.isVideo ? MediaType.video : MediaType.photo,
            );
          }).toList();

          if(handleSelected.isNotNull) {
            handleSelected!(files);
          }

          return files;
        }

        onError?.call("Unsupported file format detected. Only images or videos are allowed", true);
      }
    } catch (e) {
      onError?.call("Unsupported file format", true);
    }

    return [];
  }
}