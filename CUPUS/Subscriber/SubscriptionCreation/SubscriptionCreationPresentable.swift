struct SubscriptionCreationPresentable {
    var subscriptionTypes: [SubscriptionFilterPresentable]
    
    init(subscriptionTypes: [SubscriptionFilterPresentable]) {
        self.subscriptionTypes = subscriptionTypes
    }

    static var mock: SubscriptionCreationPresentable {
        return SubscriptionCreationPresentable(subscriptionTypes: [
            SubscriptionFilterPresentable(title: "CO2"),
            SubscriptionFilterPresentable(title: "O2"),
            SubscriptionFilterPresentable(title: "Temperature"),
            SubscriptionFilterPresentable(title: "Pressure")
            ])
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
