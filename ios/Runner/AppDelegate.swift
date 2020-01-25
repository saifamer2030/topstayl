import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterVC : FlutterViewController!
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  GMSServices.provideAPIKey("AIzaSyCNsvOGMDb-O9l49lKNFRiiHpRqxteJSDw")
   
    GeneratedPluginRegistrant.register(with: self)
     initApplePayment()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func initApplePayment(){
        flutterVC = window?.rootViewController as? FlutterViewController
                  let channel = FlutterMethodChannel(name: "com.topstylesa/applePay", binaryMessenger: flutterVC.binaryMessenger)

                     channel.setMethodCallHandler { [unowned self] (methodCall, result) in
                         guard let arg = (methodCall.arguments as! [String]).first else { return

                        }
                         switch methodCall.method {
                         case "applePay":
                             self.openAlertPayment(param: arg, result: result)
                         default:
                             debugPrint(methodCall.method)
                             result(methodCall.method)
                         }
                     }
    }
    private func openAlertPayment(param: String, result: @escaping FlutterResult ) {
                 let alert = UIAlertController(title: "Apple Payment" , message: param, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                        result("Ok was pressed")
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                        result("Cancel was pressed")
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    flutterVC.present(alert, animated: true, completion: nil)
                }

}
