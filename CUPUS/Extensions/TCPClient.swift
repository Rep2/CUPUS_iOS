import SwiftSocket

extension TCPClient {
    func asyncSend(data: Data, callback: @escaping (Result) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.send(data: data)

            callback(result)
        }
    }

    func asyncRead(callback: @escaping ([Byte]?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            while let strongSelf = self {
                let result = strongSelf.read(1000)

                callback(result)
            }
        }
    }
}
