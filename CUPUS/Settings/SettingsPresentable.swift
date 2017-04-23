struct Settings {
    var ip: String
    var port: Int32
    
    var readPeriod = 1.0
    var sendPeriod = 60.0
    
    init(ip: String = "127.0.0.1", port: Int32 = 10000, readPeriod: Double = 1.0, sendPeriod: Double = 60.0) {
        self.ip = ip
        self.port = port
        self.readPeriod = readPeriod
        self.sendPeriod = sendPeriod
    }
}
