import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let mapApi = FlutterMethodChannel(name: "com.serchservice.drive/apiKey", binaryMessenger: controller.binaryMessenger)

    mapApi.invokeMethod("getMapApiKey", arguments: nil) { (result: Any?) in
      if let apiKey = result as? String {
        GMSServices.provideAPIKey(apiKey)
      }
    }

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
