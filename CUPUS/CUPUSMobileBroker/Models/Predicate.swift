public struct Predicate: JSON {
    let value: String
    let key: String
    let predicateOperator: Operator
    
    public init(value: String, key: String, predicateOperator: Operator) {
        self.value = value
        self.key = key
        self.predicateOperator = predicateOperator
    }
    
    var jsonDictionary: [String : Any] {
        return [
            "value": value,
            "key": key,
            "operator": predicateOperator.identifier
        ]
    }
}

public enum Operator {
    case equal
    case less
    case more
    
    var identifier: String {
        switch self {
        case .equal:
            return "EQUAL"
        case .less:
            return "LESS"
        case .more:
            return "MORE"
        }
    }
}
