import RxSwift
import CoreLocation

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

    var buffer: [Float]!
    var notSentValues = [(Float, Float, [Float])]()

    var currentValue: Float?
    var maximumValue: Float?
    var minimumValue: Float?
    var timeSinceStart: Double?
    
    private var startTime: Date?
    
    var readPeriod = SettingsPresenter.sharedInstance.settings.readPeriod
    
    var disposable: Disposable?

    private let ps: Float = 20/1000000
    private let kal: Float = 5

    var publishTimer: Timer?
    
    func stateChanged(on: Bool) {
        if on && !isRecording {
            let settings = SettingsPresenter.sharedInstance.settings

            publishTimer = Timer.scheduledTimer(withTimeInterval: settings.sendPeriod, repeats: true, block: { _ in
                if let location = LocationManager.sharedInstance.location.value {
                    if self.notSentValues.count > 0 {
                        self.notSentValues.forEach({ (minimum, maximum, values) in
                            self.sendPublication(minimumValue: minimum, maximumValue: maximum, values: values, location: location)
                        })
                    }

                    self.sendPublication(minimumValue: self.minimumValue ?? 0, maximumValue: self.maximumValue ?? 0, values: self.buffer ?? [], location: location)
                } else {
                    self.notSentValues.append((self.minimumValue ?? 0, self.maximumValue ?? 0, self.buffer))
                }

                self.buffer = []

            })

            isRecording = true

            buffer = []
            currentValue = nil
            maximumValue = nil
            minimumValue = nil
            
            startTime = Date()
            timeSinceStart = 0
            
            readPeriod = SettingsPresenter.sharedInstance.settings.readPeriod
            
            disposable = AudioRecorder.sharedInstance
                .recorde(readPeriod: SettingsPresenter.sharedInstance.settings.readPeriod)
                .subscribe(onNext: newValue)
        } else if !on && isRecording {
            isRecording = false
            publishTimer?.invalidate()
            
            disposable?.dispose()
        }
    }

    func sendPublication(minimumValue: Float, maximumValue: Float, values: [Float], location: CLLocation) {
        let settings = SettingsPresenter.sharedInstance.settings

        let antiLoged = values
            .map { pow(10, $0/20.0) }
            .reduce(0) { $0 + $1 }

        let avgValue = 20.0 * log10(
            antiLoged / Float(values.count)
        )

        print(avgValue)

        Publisher.publish(ip: settings.ip, port: settings.port, geometry: Geometry.point(x: location.coordinate.latitude, y: location.coordinate.longitude), properties: [
            Property(value: "SensorReading", key: "Type"),
            Property(value: avgValue, key: SubscriptionValue.ambientNoiseIdentifier + "Avg"),
            Property(value: minimumValue, key: SubscriptionValue.ambientNoiseIdentifier + "Min"),
            Property(value: maximumValue, key: SubscriptionValue.ambientNoiseIdentifier + "Max"),
            Property(value: values, key: SubscriptionValue.ambientNoiseIdentifier)
            ], callback: { result in
                switch result {
                case .success:
                    print("Publication succeded")
                case .failure(let error):
                    print("Publication send failed \(error)")
                }
        })
    }

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss.SSSS"
        
        return dateFormatter
    }()

    func newValue(rawValue: Float) {
        let value = 20 * log10(pow(10, (rawValue/20)) / ps) + kal

        currentValue = value

        buffer?.append(value)

        if maximumValue == nil || value > maximumValue! {
            maximumValue = value
        }

        if minimumValue == nil || value < minimumValue! {
            minimumValue = value
        }

        if let startTime = startTime {
            timeSinceStart = Date().timeIntervalSince(startTime)
        }

        writeToLog(rawValue: rawValue, value: value, date: Date())

        recievedNewValue.onNext(AudioSensorPresentable(currentValue: currentValue!, maximumValue: maximumValue!, minimumValue: minimumValue!, timeSinceStart: timeSinceStart!))
    }

    func writeToLog(rawValue: Float, value: Float, date: Date) {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last! as NSURL
        let logURL = directory.appendingPathComponent("CUPUSAudioRecordingLog.txt")!
        
        do {
            let location = LocationManager.sharedInstance.location.value

            try "\(dateFormatter.string(from: date)) rawValue: \(rawValue) finalValue: \(value) location: (\(location?.coordinate.latitude ?? 0),\(location?.coordinate.longitude ?? 0))".writeLine(to: logURL)
        } catch {
            print("Failed to write to log")
        }
    }
    
    
}
