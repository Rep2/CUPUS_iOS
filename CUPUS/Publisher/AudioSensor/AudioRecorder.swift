import Foundation
import AVFoundation
import RxSwift

enum AudioRecorderError: Error {
    case failedToInitializeRecorder
    case recorderNotAvailable
}

class AudioRecorder {
    
    static let sharedInstance = AudioRecorder()
    
    init() {
        checkIfAvailable()
    }
    
    lazy var isAvaliable = BehaviorSubject<Bool>(value: false)
    
    private func checkIfAvailable() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            AVAudioSession.sharedInstance().requestRecordPermission() { allowed in
                self.isAvaliable.onNext(allowed)
            }
        } catch {
            self.isAvaliable.onNext(false)
        }
    }
    
    private let ps: Float = 20/1000000
    private let kal: Float = 5
    
    func recorde(readPeriod: Double) -> Observable<Float> {
        return isAvaliable
            .filter { $0 }
            .flatMap { _ -> Observable<Float> in
                let audioFilename = NSTemporaryDirectory() + "tmp.caf"
                let audioURL = URL(fileURLWithPath: audioFilename)
                
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatAppleIMA4) as NSNumber,
                    AVSampleRateKey: 44100 as NSNumber,
                    AVNumberOfChannelsKey: 2 as NSNumber,
                    AVLinearPCMBitDepthKey: 16 as NSNumber,
                    AVLinearPCMIsBigEndianKey: NSNumber(value: false),
                    AVLinearPCMIsFloatKey: NSNumber(value: false)
                ]
                
                if let recorder = try? AVAudioRecorder(url: audioURL, settings: settings) {
                    recorder.prepareToRecord()
                    recorder.isMeteringEnabled = true
                    recorder.record()
                    
                    return Observable.create { observable in
                        let timer = Timer.scheduledTimer(withTimeInterval: readPeriod, repeats: true, block: { _ in
                            recorder.updateMeters()
                            
                            let value = recorder.averagePower(forChannel: 0)
                            
                            let SPL = 20 * log10(pow(10, (value/20)) / self.ps) + self.kal
                            
                            observable.onNext(SPL)
                        })
                        
                        return Disposables.create {
                            timer.invalidate()
                        }
                    }
                } else {
                    return Observable.error(AudioRecorderError.failedToInitializeRecorder)
                }
        }
    }
    
}
