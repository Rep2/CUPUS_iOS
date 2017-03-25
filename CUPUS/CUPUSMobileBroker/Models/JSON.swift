import Foundation

enum JSONError: Error {
    case stringConversationFailed
    case objectParsingFailed
}

protocol JSON {
    func json() throws -> Data
    var jsonDictionary: [String: Any] { get }
}

extension JSON {
    func json() throws -> Data {
        return try JSONSerialization.data(withJSONObject: jsonDictionary) + "\n".data(using: .ascii)!
    }
}
