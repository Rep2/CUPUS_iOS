import UIKit

class TabViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let subscriptionVC = UINavigationController(rootViewController: SubscriberViewController())
        subscriptionVC.tabBarItem.title = "Pretplata"
        subscriptionVC.tabBarItem.image = #imageLiteral(resourceName: "Map")
        
        viewControllers = [
            subscriptionVC
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
