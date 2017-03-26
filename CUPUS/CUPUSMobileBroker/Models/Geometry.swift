public enum Geometry: JSON {
    case point(x: Double, y: Double)
    case polygon(pints: [(Double, Double)])
    
    var jsonDictionary: [String : Any] {
        switch self {
        case .point(let x, let y):
            return [
                "coordinates": [x, y],
                "type": "Point"
            ]
        case .polygon(let points):
            return [
                "coordinates": [points.map { [$0.0, $0.1] }],
                "type": "Polygon"
            ]
        }
    }

    static func from(json: [String: Any]) throws -> Geometry {
        guard let type = json["type"] as? String else {
            throw JSONError.objectParsingFailed
        }

        switch type {
        case "Point":
            guard let coordinates = json["coordinates"] as? [Double], coordinates.count == 2 else {
                throw JSONError.objectParsingFailed
            }

            return .point(x: coordinates[0], y: coordinates[1])
        case "Polygon":
            guard let coordinates = json["coordinates"] as? [[Double]] else {
                throw JSONError.objectParsingFailed
            }

            try coordinates.forEach { coordinate in
                guard coordinate.count == 2 else {
                    throw JSONError.objectParsingFailed
                }
            }

            return .polygon(pints: coordinates.map { ($0[0], $0[1]) })
        default:
            throw JSONError.objectParsingFailed
        }
    }
}
