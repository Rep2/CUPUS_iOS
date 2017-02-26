import GoogleMaps

class SubscriptionList {
    static let sharedInstance = SubscriptionList()
    
    var subscriptions = [Subscription]()
    var selectedSubscriptionIndex: Int?
    
    var subscriptionCount = 0
    
    func createSubscription(type: SubscriptionType, filters: [String]) {
        let subscription = Subscription(type: type, subscriptionTypes: filters)
        
        add(subscription: subscription)
    }
    
    func add(subscription: Subscription) {
        subscriptionCount += 1
        
        subscriptions.append(subscription)
        selectedSubscriptionIndex = subscriptions.count - 1
    }
    
    func selectSubscription(at indexPath: IndexPath) {
        selectedSubscriptionIndex = indexPath.row
    }
    
    var selectedSubscription: Subscription? {
        if let selectedSubscriptionIndex = selectedSubscriptionIndex {
            return subscriptions[selectedSubscriptionIndex]
        } else {
            return nil
        }
    }
    
    func removeSubscription(at indexPath: IndexPath) {
        subscriptions.remove(at: indexPath.row)
        
        if let selectedIndex = selectedSubscriptionIndex, selectedIndex == indexPath.row {
            selectedSubscriptionIndex = subscriptions.count != 0 ? 0 : nil
        }
    }

}

struct Subscription {
    let title: String
    
    let type: SubscriptionType
    let subscriptionTypes: [String]
    
    var circle: GMSCircle!
    
    init(type: SubscriptionType, subscriptionTypes: [String]) {
        self.title = "Subscription \(SubscriptionList.sharedInstance.subscriptionCount)"
        
        self.type = type
        self.subscriptionTypes = subscriptionTypes
        self.circle = nil
    }
}
