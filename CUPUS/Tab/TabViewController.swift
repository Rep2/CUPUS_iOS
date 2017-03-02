import UIKit

class TabViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let subscriptionVC = UINavigationController(rootViewController: SubscriberViewController())
        subscriptionVC.tabBarItem.title = "Subscriptions"
        subscriptionVC.tabBarItem.image = #imageLiteral(resourceName: "Map")
        
        let (_, sensorViewController) = SensorsPresenter.create()
        let sensorNavigationViewController = UINavigationController(rootViewController: sensorViewController)
        sensorNavigationViewController.tabBarItem.title = "Sensors"
        sensorNavigationViewController.tabBarItem.image = #imageLiteral(resourceName: "Sensor")
        
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController(style: .grouped))
        settingsViewController.tabBarItem.title = "Settings"
        settingsViewController.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        
        
        viewControllers = [
            subscriptionVC,
            sensorNavigationViewController,
            settingsViewController
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
