public struct Property: JSON {
    let value: Any
    let key: String

    public init(value: Any, key: String) {
        self.value = value
        self.key = key
    }
    
    var jsonDictionary: [String : Any] {
        return [
            "key": key,
            "value": value
        ]
    }

    public static var noiseKey: String {
        return "noise"
    }

    public static var typeKey: String {
        return "Type"
    }

    public static func from(json: [String: Any]) throws -> Property {
        guard let value = json["value"], let key = json["key"] as? String else {
            throw JSONError.objectParsingFailed
        }

        return Property(value: value, key: key)
    }
}
