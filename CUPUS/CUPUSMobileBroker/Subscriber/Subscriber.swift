import SwiftSocket

class Subscriber {
    static private let sharedInstance = Subscriber()
    
    private static var client: TCPClient?

    private static func clientFor(ip: String, port: Int32, callback: @escaping (ValueResult<TCPClient>) -> Void) {
        if let client = Subscriber.client {
            callback(ValueResult.success(value: client))
        } else {
            let client = TCPClient(address: ip, port: port)

            DispatchQueue.global(qos: .userInitiated).async {
                let result = client.connect(timeout: 10)

                switch result {
                case .success:

                    Subscriber.registerSubscriber(with: client, name: "iOS Subcriber", callback: { registerResult in
                        switch registerResult {
                        case .success:
                            Subscriber.client = client

                            callback(.success(value: client))
                        case .failure(let error):
                            callback(.failure(error: error))
                        }
                    })
                case .failure(let error):
                    callback(ValueResult.failure(error: error))
                }
            }
        }
    }

    private static func registerSubscriber(with client: TCPClient, name: String, callback: @escaping (Result) -> Void) {
        do {
            let message = BaseMessage(message: CUPUSMessages.registerSubscriber)
            let data = try message.json()

            client.asyncSend(data: data, callback: callback)
        } catch let error {
            callback(Result.failure(error))
        }
    }

    static func subscribe(ip: String, port: Int32, geometry: Geometry?, predicates: [Predicate], callback: @escaping (Result) -> Void, newPublicationCallback: @escaping (ValueResult<Payload>) -> Void) {

        Subscriber.clientFor(ip: ip, port: port) { clientResult in
            switch clientResult {
            case .success(let client):

                let message = BaseMessage(message: CUPUSMessages.subscribe(payload: Payload(geometry: geometry, properties: predicates), unsubscribe: false))

                do {
                    let data = try message.json()
                    
                    client.asyncSend(data: data, callback: { subscribeResult in
                        switch subscribeResult {
                        case .success:
                            client.asyncRead(callback: { bytes in
                                if let bytes = bytes, let json = try? JSONSerialization.jsonObject(with: Data(bytes: bytes), options: .allowFragments), let jsonDict = json as? [String: Any] {
                                    if let payload = try? Payload.fromBaseJSON(json: jsonDict) {
                                        newPublicationCallback(.success(value: payload))

                                        return
                                    }
                                }

                                Subscriber.client = nil

                                newPublicationCallback(.failure(error: JSONError.objectParsingFailed))
                            })
                        case .failure(let error):
                            Subscriber.client = nil

                            callback(Result.failure(error))
                        }
                    })
                } catch let error {
                    Subscriber.client = nil

                    callback(Result.failure(error))
                }

            case .failure(let error):
                Subscriber.client = nil

                callback(.failure(error))
            }
        }
    }
    
    
}
