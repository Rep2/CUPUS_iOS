import GoogleMaps

class SubscriptionHandler {
    static let sharedInstance = SubscriptionHandler()
    
    var subscriptions = [Subscription]()
    var selectedSubscriptionIndex: Int?

    var error: Error? {
        didSet {
            print(error)
        }
    }

    func sendSubscriptionSubscribe() {
        let settings = SettingsPresenter.sharedInstance.settings

        Subscriber.subscribe(ip: settings.ip, port: settings.port, geometry: nil, predicates: [
            Predicate(value: "", key: "'", predicateOperator: .equal)
            ], callback: { result in

        }) { publication in
            
        }
    }
}

extension SubscriptionHandler {
    func createSubscription(type: SubscriptionType, subscriptionValues: [SubscriptionValue]) {
        let subscription = Subscription(type: type, subscriptionValues: subscriptionValues)
        
        add(subscription: subscription)
    }
    
    func add(subscription: Subscription) {
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
