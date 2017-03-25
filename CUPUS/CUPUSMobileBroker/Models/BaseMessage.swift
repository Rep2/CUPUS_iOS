import UIKit

struct BaseMessage {
    let messageId: String
    let senderId: String
    let timestamp: Int64
        
    let message: CUPUSMessages
    
    init(messageId: String, senderId: String, timestamp: Int64, message: CUPUSMessages) {
        self.messageId = messageId
        self.senderId = senderId
        self.timestamp = timestamp
        self.message = message
    }

    init(message: CUPUSMessages) {
        self.messageId = UUID().uuidString
        self.senderId = (UIDevice.current.identifierForVendor ?? UUID()).uuidString
        self.message = message

        self.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension BaseMessage: JSON {
    var jsonDictionary: [String: Any] {
        var jsonDictionary = [
            "eid": senderId,
            "id": messageId,
            "type": message.identifier,
            "timestamp": timestamp as Any
        ]
        
        jsonDictionary["message"] = message.jsonDictionary
        
        return jsonDictionary
    }
}
