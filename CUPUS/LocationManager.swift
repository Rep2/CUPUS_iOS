import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    private let locationManager: CLLocationManager

    private var observers = [UUID: (CLLocation?) -> Void]()
    
    private var location: CLLocation?
    
    private override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            
            for (_, observer) in observers {
                observer(location)
            }
        }
    }
    
    func add(observer: @escaping (CLLocation?) -> Void) -> UUID {
        observer(location)
        
        let uuid = UUID()
        
        observers[uuid] = observer
        
        return uuid
    }
    
    func removeObserver(for uuid: UUID) {
        observers[uuid] = nil
    }
}
