import GoogleMaps

class SubscriptionList {
    static let sharedInstance = SubscriptionList()
    
    var subscriptions = [Subscription]()
    
    func add(subscription: Subscription) {
        subscriptions.append(subscription)
    }
}

enum SubscriptionState {
    case follow
    case pick
}

struct Subscription {
    let state: SubscriptionState
    let subscriptionTypes: [String]
    
    let circle: GMSCircle
}
