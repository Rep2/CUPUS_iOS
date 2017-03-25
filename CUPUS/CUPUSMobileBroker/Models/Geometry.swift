public enum Geometry: JSON {
    case point(x: Double, y: Double)
    
    var jsonDictionary: [String : Any] {
        switch self {
        case .point(let x, let y):
            return [
                "coordinates": [x, y],
                "type": "Point"
            ]
        }
    }

    static func from(json: [String: Any]) throws -> Geometry {
        guard let type = json["type"] as? String, let coordinates = json["coordinates"] as? [Double] else {
            throw JSONError.objectParsingFailed
        }

        switch type {
        case "Point":
            if coordinates.count != 2 {
                throw JSONError.objectParsingFailed
            }

            return .point(x: coordinates[0], y: coordinates[1])
        default:
            throw JSONError.objectParsingFailed
        }
    }
}
