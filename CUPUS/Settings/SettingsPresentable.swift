struct Settings {
    var ip: String
    var port: Int
    
    var readPeriod = 1.0
    var sendPeriod = 60.0
    
    init(ip: String = "161.53.19.118", port: Int = 10000, readPeriod: Double = 1.0, sendPeriod: Double = 60.0) {
        self.ip = ip
        self.port = port
        self.readPeriod = readPeriod
        self.sendPeriod = sendPeriod
    }
}
