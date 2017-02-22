import UIKit

enum LongPressHadnlerEvent {
    case started
    case ended
}

class LongPressHadnler: NSObject {
    
    var gestureRecognizer: UILongPressGestureRecognizer!
    var longPressActive = false
    
    let valueChangedCallback: (LongPressHadnlerEvent) -> Void
    
    init(minimumPressDuration: Double, in view: UIView, callback: @escaping (LongPressHadnlerEvent) -> Void) {
        valueChangedCallback = callback
        
        super.init()
        
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LongPressHadnler.longPressEvent))
        gestureRecognizer.minimumPressDuration = minimumPressDuration
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func longPressEvent() {
        valueChangedCallback(longPressActive ? .ended : .started)
        
        longPressActive = !longPressActive
    }
    
    func pressLocation(in view: UIView) -> CGPoint {
        return gestureRecognizer.location(in: view)
    }
}
