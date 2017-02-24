struct NewSubscriptionPresentable {
    var subscriptionTypes: [SubscriptionType]
    
    init(subscriptionTypes: [SubscriptionType]) {
        self.subscriptionTypes = subscriptionTypes
    }

    static var mock: NewSubscriptionPresentable {
        return NewSubscriptionPresentable(subscriptionTypes: [
            SubscriptionType(title: "CO2"),
            SubscriptionType(title: "O2"),
            SubscriptionType(title: "Temperature"),
            SubscriptionType(title: "Pressure")
            ])
    }
}

struct SubscriptionType: BasicCellPresentable {
    let title: String
    var selected: Bool
    
    init(title: String, selected: Bool = false) {
        self.title = title
        self.selected = selected
    }
}
