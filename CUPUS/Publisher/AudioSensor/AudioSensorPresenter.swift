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
    
    var disposable: Disposable?
    
    func stateChanged(on: Bool) {
        if on && !isRecording {
            isRecording = true
            
            currentValue = nil
            maximumValue = nil
            minimumValue = nil
            
            startTime = Date()
            timeSinceStart = 0
            
            disposable = AudioRecorder.sharedInstance.recorde(readPeriod: SettingsPresenter.sharedInstance.settings.readPeriod)
                .subscribe(
                    onNext: { value in
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
                        
                        self.recievedNewValue.onNext(AudioSensorPresentable(currentValue: self.currentValue!, maximumValue: self.maximumValue!, minimumValue: self.minimumValue!, timeSinceStart: self.timeSinceStart!))
                }
            )
        } else if !on && isRecording {
            isRecording = false
            
            disposable?.dispose()
        }
    }
    
    
}
