struct SubscriptionCreationPresentable {
    var subscriptionTypes: [SubscriptionTypePresentable]
    
    init(subscriptionTypes: [SubscriptionTypePresentable]) {
        self.subscriptionTypes = subscriptionTypes
    }

    static var presentable: SubscriptionCreationPresentable {
        return SubscriptionCreationPresentable(subscriptionTypes: SubscriptionValue.values.map {
            SubscriptionTypePresentable(title: $0.printableText)
        })
    }
}

struct SubscriptionTypePresentable: BasicCellPresentable {
    let title: String
    var selected: Bool
    
    init(title: String, selected: Bool = false) {
        self.title = title
        self.selected = selected
    }
}
