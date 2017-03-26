import SwiftSocket

public class Publisher {
    private static var client: TCPClient?

    private static func clientFor(ip: String, port: Int32, callback: @escaping (ValueResult<TCPClient>) -> Void) {
        if let client = Publisher.client {
            callback(ValueResult.success(value: client))
        } else {
            let client = TCPClient(address: ip, port: port)

            DispatchQueue.global(qos: .userInitiated).async {
                let result = client.connect(timeout: 10)

                switch result {
                case .success:

                    Publisher.registerPublisher(with: client, name: "iOS Publisher", callback: { registerResult in
                        switch registerResult {
                        case .success:
                            Publisher.client = client

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

    private static func registerPublisher(with client: TCPClient, name: String, callback: @escaping (Result) -> Void) {
        do {
            let message = BaseMessage(message: CUPUSMessages.registerPublisher(name: name))
            let data = try message.json()

            client.asyncSend(data: data, callback: callback)
        } catch let error {
            callback(Result.failure(error))
        }
    }
    
    static func publish(ip: String, port: Int32, geometry: Geometry, properties: [Property], callback: @escaping (Result) -> Void) {
        Publisher.clientFor(ip: ip, port: port) { clientResult in
            switch clientResult {
            case .success(let client):
                let message = BaseMessage(message: CUPUSMessages.publish(payload: Payload(geometry: geometry, properties: properties), unpublish: false))

                do {
                    let data = try message.json()

                    client.asyncSend(data: data, callback: { publishResult in
                        if case .failure = publishResult {
                            Publisher.client = nil
                        }

                        callback(publishResult)
                    })
                } catch let error {
                    Publisher.client = nil

                    callback(Result.failure(error))
                }
            case .failure(let error):
                Publisher.client = nil
                
                callback(.failure(error))
            }
        }
    }
}
