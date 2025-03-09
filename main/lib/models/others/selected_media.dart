import 'package:smart/smart.dart' show MediaType, StringExtensions, JsonUtils, Instance, EnumExtension;
import 'package:universal_io/io.dart';
import 'dart:typed_data';

class SelectedMedia{
  final String path;
  final String size;
  final String duration;
  final Uint8List? data;
  final String? callbackUrl;
  final MediaType media;
  final bool isCamera;

  SelectedMedia({
    required this.path,
    this.duration = "00:00",
    this.size = "",
    this.data,
    this.callbackUrl,
    this.isCamera = false,
    this.media = MediaType.photo
  });

  SelectedMedia copyWith({
    String? path,
    String? duration,
    String? size,
    Uint8List? data,
    String? callbackUrl,
    MediaType? media,
    bool? isCamera,
  }) {
    return SelectedMedia(
      path: path ?? this.path,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      data: data ?? this.data,
      media: media ?? this.media,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      isCamera: isCamera ?? this.isCamera
    );
  }

  Map<String, dynamic> toJson() => {
    "path": path,
    "duration": duration,
    "size": size,
    "data": data,
    "callback_url": callbackUrl,
    "media": media.type,
    "is_camera": isCamera
  };

  String toJsonString(SelectedMedia media) {
    return JsonUtils.instance.encode(media.toJson());
  }

  factory SelectedMedia.fromJson(dynamic data) {
    if(Instance.of<String>(data)) {
      data = JsonUtils.instance.decode(data);
    }

    return SelectedMedia(
      path: data["path"] ?? "",
      duration: data["duration"] ?? "",
      size: data["size"] ?? "",
      data: data["data"],
      callbackUrl: data["callback_url"],
      isCamera: data["is_camera"] ?? false,
      media: data["media"] != null ? (data["media"] as String).toMediaType : MediaType.photo
    );
  }

  bool get hasContent => path.isNotEmpty || data != null;

  Future<String> getBase64() async {
    Uint8List fileBytes = await File(path).readAsBytes();
    return JsonUtils.instance.encode(fileBytes);
  }

  Future<String> getBase64WithPrefix() async {
    String base64String = await getBase64();

    return 'data:${path.mimeType};base64,$base64String';
  }
}