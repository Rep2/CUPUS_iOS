import CoreLocation

struct Subscription {
    let type: SubscriptionType
    let subscriptionValues: [SubscriptionValue]
    
    init(type: SubscriptionType, subscriptionValues: [SubscriptionValue]) {
        self.type = type
        self.subscriptionValues = subscriptionValues
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

struct SubscriptionValue {
    let identifier: String
    let printableText: String

    static var values: [SubscriptionValue] {
        return [
            SubscriptionValue(identifier: "humidity", printableText: "Humidity"),
            SubscriptionValue(identifier: "ambientLight", printableText: "Ambient Light"),
            SubscriptionValue(identifier: "ambientNoise", printableText: "Ambient Noise"),
            SubscriptionValue(identifier: "temperature", printableText: "Temperature")
        ]
    }
}
