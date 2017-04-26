import UIKit

enum CUPUSMessages: JSON {
    case registerPublisher
    case registerSubscriber
    case publish(payload: Payload, unpublish: Bool)
    case subscribe(payload: Payload, unsubscribe: Bool)

    var identifier: String {
        switch self {
        case .registerPublisher:
            return "PublisherRegisterMessage"
        case .registerSubscriber:
            return "SubscriberTcpRegisterMessage"
        case .publish:
            return "PublishMessage"
        case .subscribe:
            return "SubscribeMessage"
        }
    }
    
    var jsonDictionary: [String: Any] {
        switch self {
        case .registerPublisher:
            return [
                "en": "Publisher",
                "id": (UIDevice.current.identifierForVendor ?? UUID()).uuidString
            ]
        case .registerSubscriber:
            return [
                "port": "0",
                "ip": getWiFiAddress() ?? "127.0.0.1",
                "en": "Subscriber",
                "id": (UIDevice.current.identifierForVendor ?? UUID()).uuidString
            ]
        case .publish(let payload, let unpublish):
            return [
                "unpublish": unpublish,
                "type": "HashtablePublication",
                "payload": payload.jsonDictionary
            ]
        case .subscribe(let payload, let unsubscribe):
            return [
                "unsubscribe": unsubscribe,
                "type": "TripletSubscription",
                "payload": payload.jsonDictionary,
            ]
        }
    }
}
