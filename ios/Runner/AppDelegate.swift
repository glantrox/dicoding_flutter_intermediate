import UIKit
import Flutter
import GoogleMaps  
 
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
 
    GMSServices.provideAPIKey("AIzaSyCN7gdbXQ0F6rq-x0My9xQXMTvhJ8t1vWI")
 
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}