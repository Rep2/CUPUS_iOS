struct SettingsCellPresentable {
    let title: String
    let value: String
    let valueUpdatedCallback: (String) -> String
}

extension SettingsCellPresentable: InputCellPresentable {
    var input: String {
        return value
    }
    
    var inputViewDidChange: (String) -> String {
        return valueUpdatedCallback
    }
}

struct SettingsCellSectionPresentable {
    let title: String
    let presentables: [SettingsCellPresentable]
}
