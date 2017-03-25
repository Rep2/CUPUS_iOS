struct SubscriptionCreationPresentable {
    var subscriptionTypes: [SubscriptionFilterPresentable]
    
    init(subscriptionTypes: [SubscriptionFilterPresentable]) {
        self.subscriptionTypes = subscriptionTypes
    }

    static var presentable: SubscriptionCreationPresentable {
        return SubscriptionCreationPresentable(subscriptionTypes: SubscriptionValue.values.map {
            SubscriptionFilterPresentable(title: $0.printableText)
        })
    }
}

struct SubscriptionFilterPresentable: BasicCellPresentable {
    let title: String
    var selected: Bool
    
    init(title: String, selected: Bool = false) {
        self.title = title
        self.selected = selected
    }
}
