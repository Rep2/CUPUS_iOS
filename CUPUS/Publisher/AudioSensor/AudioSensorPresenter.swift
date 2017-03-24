import RxSwift

struct AudioSensorPresentable {
    let currentValue: Float
    let maximumValue: Float
    let minimumValue: Float
    
    let timeSinceStart: Double
}

class AudioSensorPresenter {
    
    static let sharedInstance = AudioSensorPresenter()
    
    let recievedNewValue = PublishSubject<AudioSensorPresentable>()
    
    var isRecording = false
    
    var currentValue: Float?
    var maximumValue: Float?
    var minimumValue: Float?
    var timeSinceStart: Double?
    
    private var startTime: Date?
    
    var readPeriod = SettingsPresenter.sharedInstance.settings.readPeriod
    
    var disposable: Disposable?

    private let ps: Float = 20/1000000
    private let kal: Float = 5
    
    func stateChanged(on: Bool) {
        if on && !isRecording {
            isRecording = true
            
            currentValue = nil
            maximumValue = nil
            minimumValue = nil
            
            startTime = Date()
            timeSinceStart = 0
            
            readPeriod = SettingsPresenter.sharedInstance.settings.readPeriod
            
            disposable = AudioRecorder.sharedInstance.recorde(readPeriod: SettingsPresenter.sharedInstance.settings.readPeriod)
                .subscribe(
                    onNext: { rawValue in
                        let value = 20 * log10(pow(10, (rawValue/20)) / self.ps) + self.kal

                        self.currentValue = value
                        
                        if self.maximumValue == nil || value > self.maximumValue! {
                            self.maximumValue = value
                        }
                        
                        if self.minimumValue == nil || value < self.minimumValue! {
                            self.minimumValue = value
                        }
                        
                        if let startTime = self.startTime {
                            self.timeSinceStart = Date().timeIntervalSince(startTime)
                        }
                        
                       self.writeToLog(rawValue: rawValue, value: value, date: Date())
                        
                        self.recievedNewValue.onNext(AudioSensorPresentable(currentValue: self.currentValue!, maximumValue: self.maximumValue!, minimumValue: self.minimumValue!, timeSinceStart: self.timeSinceStart!))
                }
            )
        } else if !on && isRecording {
            isRecording = false
            
            disposable?.dispose()
        }
    }
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss.SSSS"
        
        return dateFormatter
    }()
    
    func writeToLog(rawValue: Float, value: Float, date: Date) {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last! as NSURL
        let logURL = directory.appendingPathComponent("CUPUSAudioRecordingLog.txt")!
        
        do {
            try "\(dateFormatter.string(from: date)) rawValue: \(rawValue) finalValue: \(value)".writeLine(to: logURL)
        } catch {
            print("Failed to write to log")
        }
    }
    
    
}
