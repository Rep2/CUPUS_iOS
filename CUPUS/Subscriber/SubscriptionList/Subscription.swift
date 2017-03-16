import CoreLocation

struct Subscription {
    let type: SubscriptionType
    let subscriptionTypes: [String]
    
    init(type: SubscriptionType, subscriptionTypes: [String]) {
        self.type = type
        self.subscriptionTypes = subscriptionTypes
    }
    
    var circle: Circle {
        switch self.type {
        case .follow(let radiusInMeters):
            let location = LocationManager.sharedInstance.location.value ?? CLLocation(latitude: 45.8144400, longitude: 15.9779800)
            
            return Circle(position: location.coordinate, radius: radiusInMeters)
        case .pick(let circle):
            return circle
        }
    }
}
