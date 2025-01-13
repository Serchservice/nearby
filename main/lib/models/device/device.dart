class Device {
  final String name;
  final String id;
  final String ipAddress;
  final String platform;
  final int sdk;
  final String host;
  final String operatingSystem;
  final String operatingSystemVersion;
  final String localHostName;

  Device({
    required this.name,
    required this.id,
    required this.ipAddress,
    required this.platform,
    this.sdk = 0,
    required this.host,
    required this.operatingSystem,
    required this.operatingSystemVersion,
    required this.localHostName,
  });

  Device copyWith({
    String? name,
    String? id,
    String? ipAddress,
    String? platform,
    int? sdk,
    String? host,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostName,
  }) {
    return Device(
      name: name ?? this.name,
      id: id ?? this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      platform: platform ?? this.platform,
      sdk: sdk ?? this.sdk,
      host: host ?? this.host,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      operatingSystemVersion: operatingSystemVersion ?? this.operatingSystemVersion,
      localHostName: localHostName ?? this.localHostName,
    );
  }

  factory Device.empty() {
    return Device(
      name: "",
      id: "",
      ipAddress: "",
      platform: "",
      sdk: 0,
      host: "",
      operatingSystem: "",
      operatingSystemVersion: "",
      localHostName: ""
    );
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      name: json["name"] ?? "",
      id: json["id"] ?? "",
      ipAddress: json["ip_address"] ?? "",
      platform: json["platform"] ?? "",
      sdk: json["sdk"] ?? 0,
      host: json["host"] ?? "",
      operatingSystem: json["operating_system"] ?? "",
      operatingSystemVersion: json["operating_system_version"] ?? "",
      localHostName: json["local_host_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "ip_address": ipAddress,
    "platform": platform,
    "sdk": sdk,
    "host": host,
    "operating_system": operatingSystem,
    "operating_system_version": operatingSystemVersion,
    "local_host_name": localHostName,
  };
}