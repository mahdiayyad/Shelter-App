import UIKit
import Flutter
import GoogleMaps 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     GMSServices.provideAPIKey("AIzaSyBhGHtI_qd6sHlVOut1kpnZgj_7SkUsk7g")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
