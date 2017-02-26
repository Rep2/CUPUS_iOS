enum SubscriptionType {
    case follow(radiusInMeters: Double)
    case pick(circle: Circle)
}

// MARK: subscription creation presentable

extension SubscriptionType {
    func numberOfRows(for section: Int, presentable: SubscriptionCreationPresentable) -> Int {
        switch (self, section) {
        case (.follow, 1), (.pick, 0):
            return presentable.subscriptionTypes.count
        default:
            return 1
        }
    }
    
    var numbeOfSections: Int {
        switch self {
        case .follow:
            return 3
        case .pick:
            return 2
        }
    }
}
