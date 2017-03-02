class SettingsPresenter {
    static let sharedInstance = SettingsPresenter()
    
    var settingsPresentable = SettingsPresentable(ip: "161.53.19.118", port: 10000)
    
    var readPeriod = 1.0
    var sendPeriod = 60.0
    
    
}
