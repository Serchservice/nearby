import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class AssetUtility {
  static ImageProvider image(String image, {String? fallback}) {
    if(image.startsWith('http')) {
      return CachedNetworkImageProvider(
        image,
        errorListener: (obj) => AssetImage(fallback ?? Assets.logoSplashWhite),
      );
    } else if(image.startsWith('/')) {
      return FileImage(File(image));
    } else if(image.startsWith('data:image')) {
      return MemoryImage(base64Decode(image.split(",").last));
    } else if(image.isNotEmpty) {
      return AssetImage(image);
    } else {
      return AssetImage(
        Database.preference.isDarkTheme
          ? Assets.commonDriveCarBlack
          : Assets.commonDriveCarWhite
      );
    }
  }
}