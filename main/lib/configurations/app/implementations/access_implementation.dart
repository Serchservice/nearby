import 'package:geolocator/geolocator.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart' show IterableExtension;
import 'package:permission_handler/permission_handler.dart';

class AccessImplementation implements AccessService {
  @override
  Future<bool> hasLocation() async {
    LocationPermission permit = await Geolocator.checkPermission();
    return permit == LocationPermission.always || permit == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      throw SerchException("Location service is not enabled on this device", isPlatformNotSupported: true);
    }

    var permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> checkForStorageOrAskPermission(int sdk) async {
    List<Permission> storagePermissions(int sdk) => [
      if(PlatformEngine.instance.isAndroid) ...[
        if(sdk <= 32) ...[
          Permission.storage,
        ] else ...[
          Permission.photos,
          // Permission.manageExternalStorage
        ]
      ] else if(PlatformEngine.instance.isIOS) ...[
        Permission.photosAddOnly,
        Permission.photos,
        Permission.storage
      ],
    ];

    var storagePermission = await [...storagePermissions(sdk)].request();
    Iterable<MapEntry<Permission, PermissionStatus>> permissions = storagePermission.entries;

    return permissions.all((element) => element.value.isGranted);
  }
}