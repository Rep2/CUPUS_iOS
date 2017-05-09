import Foundation

struct Payload: JSON {
    let geometry: Geometry?
    let properties: [JSON]
    let startTime: Int64
    let validity: Int64

    init(geometry: Geometry? = nil, properties: [JSON], startTime: Int64, validity: Int64) {
        self.geometry = geometry
        self.properties = properties
        self.startTime = startTime
        self.validity = validity
    }

    init(geometry: Geometry? = nil, properties: [JSON], startDate: Date? = nil, endDate: Date? = nil) {
        self.geometry = geometry
        self.properties = properties

        if let startDate = startDate {
            self.startTime = Int64(startDate.timeIntervalSince1970 * 1000)
        } else {
            self.startTime = Int64(Date().timeIntervalSince1970 * 1000)
        }

        if let endDate = endDate {
            self.validity = Int64(endDate.timeIntervalSince1970 * 1000)
        } else {
            self.validity = -1
        }
    }
    
    var jsonDictionary: [String : Any] {
        var jsonDictionary: [String : Any] = [
            "startTime": startTime,
            "validity": validity,
            "properties": properties.map { $0.jsonDictionary }
        ]

        jsonDictionary["geometry"] = geometry?.jsonDictionary

        return jsonDictionary
    }

    static func from(json: [String: Any]) throws -> Payload {
        guard let startTime = json["startTime"] as? Int64,
            let validity = json["validity"] as? Int64,
            let geometry = json["geometry"] as? [String: Any],
            let properties = json["properties"] as? [[String: Any]] else {
                throw JSONError.objectParsingFailed
        }

        return try Payload(geometry: Geometry.from(json: geometry), properties: properties.map { try Property.from(json: $0) }, startTime: startTime, validity: validity)
    }

    static func fromBaseJSON(json: [String: Any]) throws -> Payload {
        guard let messageIdentifier = json["type"] as? String,
            let message = json["message"] as? [String: Any],
            let payload = message["payload"] as? [String: Any] else {
                throw JSONError.objectParsingFailed
        }

        switch messageIdentifier {
        case "NotifyMessage":
            return  try Payload.from(json: payload)
        default:
            throw JSONError.objectParsingFailed
        }
    }
}
