import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    let googleAPIKey = "AIzaSyDeCppDm-gsPzKfnBho1ihJxBsROVg-Vr0"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(googleAPIKey)
        
        window?.rootViewController = TabViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

