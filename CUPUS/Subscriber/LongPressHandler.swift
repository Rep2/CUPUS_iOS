import UIKit

enum LongPressHadnlerEvent {
    case started
    case ended
}

class LongPressHadnler: NSObject {
    
    var gestureRecognizer: UILongPressGestureRecognizer!
    var longPressActive = false
    
    let valueChangedCallback: (LongPressHadnlerEvent) -> Void
    
    init(minimumPressDuration: Double, in view: UIView, callback: @escaping (LongPressHadnlerEvent) -> Void, isEnabled: Bool = false) {
        valueChangedCallback = callback
        
        super.init()
        
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LongPressHadnler.longPressEvent))
        gestureRecognizer.minimumPressDuration = minimumPressDuration
        gestureRecognizer.isEnabled = isEnabled
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func longPressEvent() {
        valueChangedCallback(longPressActive ? .ended : .started)
        
        longPressActive = !longPressActive
    }
    
    func pressLocation(in view: UIView) -> CGPoint {
        return gestureRecognizer.location(in: view)
    }
    
    func set(enabled: Bool) {
        gestureRecognizer.isEnabled = enabled
    }
}
