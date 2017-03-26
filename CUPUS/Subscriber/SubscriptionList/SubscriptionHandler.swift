import GoogleMaps

class SubscriptionHandler {
    static let sharedInstance = SubscriptionHandler()
    
    var subscriptions = [Subscription]()
    var selectedSubscriptionIndex: Int?

    func sendSubscription(geometry: Geometry, predicates: [Predicate]) {
        let settings = SettingsPresenter.sharedInstance.settings

        Subscriber.subscribe(ip: settings.ip, port: settings.port, geometry: geometry, predicates: predicates, callback: { result in
                switch result {
                case .failure(let error):
                    self.subscriptionFailed()
                    print("\(error) while sending subscription")
                case .success:
                    print("subscription sent")
                }
        }) { publicationResult in
            switch publicationResult {
            case .failure(let error):
                self.subscriptionFailed()
                print("\(error) while sending subscription")
            case .success(let publication):
                print("recieved publication \(publication)")
            }
        }
    }
}

extension SubscriptionHandler {
    func createSubscription(type: SubscriptionType, subscriptionValues: [SubscriptionValue]) {
        let subscription = Subscription(type: type, subscriptionValues: subscriptionValues)
        
        add(subscription: subscription)

        let locations = [
            location(bearing: 45, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 135, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 225, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 315, distanceMeters: subscription.circle.radius, origin: subscription.circle.position)
        ]

        let rectangle = Geometry.square(point1: (locations[0].latitude, locations[0].longitude), point2: (locations[1].latitude, locations[1].longitude), point3: (locations[2].latitude, locations[2].longitude), point4: (locations[3].latitude, locations[3].longitude))

        let predicates = subscriptionValues.map {
            Predicate(value: "id", key: $0.identifier, predicateOperator: .equal)
        }

        sendSubscription(geometry: rectangle, predicates: predicates)
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

    func subscriptionFailed() {
        subscriptions.removeAll()
        selectedSubscriptionIndex = nil
    }
}
