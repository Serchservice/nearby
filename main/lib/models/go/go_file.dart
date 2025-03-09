class GoFile {
  GoFile({
    required this.file,
    required this.size,
    required this.type,
    required this.duration,
    required this.assetId,
    required this.publicId,
  });

  final String file;
  final String size;
  final String type;
  final String duration;
  final String assetId;
  final String publicId;

  GoFile copyWith({
    String? file,
    String? size,
    String? type,
    String? duration,
    String? assetId,
    String? publicId,
  }) {
    return GoFile(
      file: file ?? this.file,
      size: size ?? this.size,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      assetId: assetId ?? this.assetId,
      publicId: publicId ?? this.publicId,
    );
  }

  factory GoFile.fromJson(Map<String, dynamic> json){
    return GoFile(
      file: json["file"] ?? "",
      size: json["size"] ?? "",
      type: json["type"] ?? "",
      duration: json["duration"] ?? "",
      assetId: json["asset_id"] ?? "",
      publicId: json["public_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "file": file,
    "size": size,
    "type": type,
    "duration": duration,
    "asset_id": assetId,
    "public_id": publicId,
  };

  @override
  String toString(){
    return "$file, $size, $type, $duration, $assetId, $publicId, ";
  }
}