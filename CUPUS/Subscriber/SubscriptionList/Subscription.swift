import CoreLocation

class Subscription {
    let identifier: String
    let type: SubscriptionType
    let subscriptionValues: [SubscriptionValue]

    var payloads: [Payload]
    
    init(type: SubscriptionType, subscriptionValues: [SubscriptionValue], payloads: [Payload] = []) {
        self.type = type
        self.subscriptionValues = subscriptionValues
        self.payloads = payloads

        self.identifier = UUID().uuidString
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
            SubscriptionValue(identifier: SubscriptionValue.humidityIdentifier, printableText: "Humidity"),
            SubscriptionValue(identifier: SubscriptionValue.ambientLightIdentifier, printableText: "Ambient Light"),
            SubscriptionValue(identifier: SubscriptionValue.ambientNoiseIdentifier, printableText: "Ambient Noise"),
            SubscriptionValue(identifier: SubscriptionValue.temperatureIdentifier, printableText: "Temperature")
        ]
    }

    static var identifiers: [String] {
        return [
            ambientNoiseIdentifier,
            humidityIdentifier,
            ambientLightIdentifier,
            temperatureIdentifier
        ]
    }

    static var printableText: [String: String] {
        return [
            ambientNoiseIdentifier: "Ambient Noise",
            humidityIdentifier: "Humidity",
            ambientLightIdentifier: "Ambient Light",
            temperatureIdentifier: "Temperature"
        ]
    }

    static var ambientNoiseIdentifier = "ambientNoise"
    static var humidityIdentifier = "humidity"
    static var ambientLightIdentifier = "ambientLight"
    static var temperatureIdentifier = "temperature"
}
