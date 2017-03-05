import UIKit
import RxSwift

class AudioSensorViewController: UIViewController, Identifiable {

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
        
        dateFormater.dateFormat = "mm:ss"
        
        updateReadIntervalText()
        
        updateValues()
        
        AudioSensorPresenter.sharedInstance.recievedNewValue
            .subscribe(onNext: { [weak self] _ in
                self?.updateValues()
            }).addDisposableTo(disposeBag)
        
        
        AudioRecorder.sharedInstance.isAvaliable
            .subscribe(onNext: { [weak self] value in
                self?.isRecordingSwitch.isEnabled = value
            }).addDisposableTo(disposeBag)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        AudioSensorPresenter.sharedInstance.stateChanged(on: sender.isOn)
        
        updateReadIntervalText()
        
        if sender.isOn {
            updateValues()
        }
    }
    
    func updateReadIntervalText() {
         readInterval.text = "Read interval: \(SettingsPresenter.sharedInstance.settings.readPeriod)"
    }
    
    func updateValues() {
        let presenter = AudioSensorPresenter.sharedInstance
        
        isRecordingSwitch.isOn = presenter.isRecording
    
        currentValue.attributedText = currentValueAttributedString(value: presenter.currentValue ?? 0)
        maximumValue.text = "Maximum value: \(presenter.maximumValue?.roundTo(places: 2) ?? 0)"
        minimumValue.text = "Minimum value: \(presenter.minimumValue?.roundTo(places: 2) ?? 0)"

        let activeFor = Date(timeIntervalSinceReferenceDate: presenter.timeSinceStart ?? 0)
        recordingFor.text = "Recording for: \(dateFormater.string(from: activeFor))"
    }
    
    func currentValueAttributedString(value: Float) -> NSAttributedString {
        let smallFont = [NSFontAttributeName: UIFont(name: "Helvetica", size: 40)!]
        
        let currentValue = "\(value.roundTo(places: 2))db"
        let attributedString = NSMutableAttributedString(string: currentValue)
        attributedString.addAttributes(smallFont, range: NSRange(location: currentValue.characters.count - 2, length: 2))
        
        return attributedString
    }
}
