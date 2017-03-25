public enum Geometry: JSON {
    case point(x: Double, y: Double)
    case square(point1: (Double, Double), point2: (Double, Double), point3: (Double, Double), point4: (Double, Double))
    
    var jsonDictionary: [String : Any] {
        switch self {
        case .point(let x, let y):
            return [
                "coordinates": [x, y],
                "type": "Point"
            ]
        case .square(let point1, let point2, let point3, let point4):
            return [
                "coordinates": [point1.0, point1.1, point2.0, point2.1, point3.0, point3.1, point4.0, point4.1],
                "type": "Rectangle"
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
        case "Rectangle":
            if coordinates.count != 8 {
                throw JSONError.objectParsingFailed
            }

            return .square(point1: (coordinates[0], coordinates[1]), point2: (coordinates[2], coordinates[3]), point3: (coordinates[4], coordinates[5]), point4: (coordinates[6], coordinates[7]))
        default:
            throw JSONError.objectParsingFailed
        }
    }
}
