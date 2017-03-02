import UIKit
import RxSwift

class AudioSensor: UIViewController, Identifiable {

    @IBOutlet weak var readInterval: UILabel!
    @IBOutlet weak var recordingFor: UILabel!
    @IBOutlet weak var isRecordingSwitch: UISwitch!

    @IBOutlet weak var maximumValue: UILabel!
    @IBOutlet weak var minimumValue: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    
    let disposeBag = DisposeBag()
    
    let dateFormater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Audio recording"
        
        readInterval.text = "Read interval: \(SettingsPresenter.sharedInstance.readPeriod)"
        isRecordingSwitch.isOn = AudioPresenter.sharedInstance.isRecording
        
        dateFormater.dateFormat = "mm:ss"
        
        updateValues()
        
        AudioPresenter.sharedInstance.recievedNewValue
            .subscribe(onNext: { [weak self] presentable in
                guard let strongSelf = self else { return }
                
                strongSelf.currentValue.text = "\(presentable.currentValue.roundTo(places: 2))"
                strongSelf.maximumValue.text = "Maximum value: \(presentable.maximumValue.roundTo(places: 2))"
                strongSelf.minimumValue.text = "Minimum value: \(presentable.minimumValue.roundTo(places: 2))"
                
                let activeFor = Date(timeIntervalSinceReferenceDate: presentable.timeSinceStart)
                strongSelf.recordingFor.text = "Recording for: \(strongSelf.dateFormater.string(from: activeFor))"
            }).addDisposableTo(disposeBag)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        AudioPresenter.sharedInstance.stateChanged(on: sender.isOn)
        
        if sender.isOn {
            updateValues()
        }
    }
    
    func updateValues() {
        let presenter = AudioPresenter.sharedInstance
        
        currentValue.text = "\(presenter.currentValue?.roundTo(places: 2) ?? 0)"
        maximumValue.text = "Maximum value: \(presenter.maximumValue?.roundTo(places: 2) ?? 0)"
        minimumValue.text = "Minimum value: \(presenter.minimumValue?.roundTo(places: 2) ?? 0)"

        let activeFor = Date(timeIntervalSinceReferenceDate: presenter.timeSinceStart ?? 0)
        recordingFor.text = "Recording for: \(dateFormater.string(from: activeFor))"
    }
}
