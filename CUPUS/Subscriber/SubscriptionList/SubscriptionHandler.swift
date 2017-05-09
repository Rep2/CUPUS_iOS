import GoogleMaps

class SubscriptionHandler {
    static let sharedInstance = SubscriptionHandler()
    
    var subscriptions = [Subscription]()
    var selectedSubscriptionIndex: Int?

    func sendSubscription(subscription: Subscription) {
        let locations = [
            location(bearing: 45, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 135, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 225, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 315, distanceMeters: subscription.circle.radius, origin: subscription.circle.position),
            location(bearing: 45, distanceMeters: subscription.circle.radius, origin: subscription.circle.position)
        ]

        let rectangle = Geometry.polygon(pints: locations.map { ($0.latitude, $0.longitude) })

        var predicates = subscription.subscriptionValues.map {
            Predicate(value: "-inf", key: $0.identifier + "Min", predicateOperator: .greater)
        }

        predicates.append(Predicate(value: "SensorReading", key: "Type", predicateOperator: .equal))

        let settings = SettingsPresenter.sharedInstance.settings

        Subscriber.subscribe(ip: settings.ip, port: settings.port, geometry: rectangle, predicates: predicates, callback: { result in
                switch result {
                case .failure:
                    self.subscriptionFailed()

                    SubscriberViewController.sharedInstance.presentAlert(title: "Failed to send subscription", message: "Check internet connection and server ip/port", actions: [UIAlertAction.init(title: "OK", style: .cancel, handler: nil)])
                case .success:
                    print("subscription sent")
                }
        }) { publicationResult in
            switch publicationResult {
            case .failure:
                self.subscriptionFailed()
                SubscriberViewController.sharedInstance.presentAlert(title: "Error while receving publication", message: "Check internet connection and server state", actions: [UIAlertAction.init(title: "OK", style: .cancel, handler: nil)])
            case .success(let publication):
                self.subscriptions
                    .filter { subscription.identifier == $0.identifier }
                    .first?
                    .payloads
                    .append(publication)
                SubscriberViewController.sharedInstance.reloadSubscription()
                print("recieved publication \(publication)")
            }
        }
    }
}

extension SubscriptionHandler {
    func createSubscription(type: SubscriptionType, subscriptionValues: [SubscriptionValue]) {
        let subscription = Subscription(type: type, subscriptionValues: subscriptionValues)
        
        add(subscription: subscription)

        sendSubscription(subscription: subscription)
    }
    
    func add(subscription: Subscription) {
        subscriptions.append(subscription)
        selectedSubscriptionIndex = subscriptions.count - 1
    }
    
    func selectSubscription(at indexPath: IndexPath) {
        selectedSubscriptionIndex = indexPath.row
    }
    
    var selectedSubscription: Subscription? {
        if let selectedSubscriptionIndex = selectedSubscriptionIndex, selectedSubscriptionIndex >= 0 && selectedSubscriptionIndex < subscriptions.count {
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

        DispatchQueue.main.async {
            SubscriberViewController.sharedInstance.mapWithCircle.deleteCircle()
        }
    }

    func new(payload: Payload, for subscription: Subscription) {
        let index = subscriptions
            .map { $0.identifier }
            .enumerated()
            .filter { $0.element == subscription.identifier }
            .first?.offset

        if let index = index {
            subscriptions[index].payloads.append(payload)

            if let selectedSubscriptionIndex = selectedSubscriptionIndex, index == selectedSubscriptionIndex {
                SubscriberViewController.sharedInstance.addMarker(for: payload)
            }
        }

    }
}
