import UIKit
import GoogleMaps

class SubscriberViewController: BaseViewController {
    
    let zagrebLoaction = CLLocation(latitude: 45.8144400, longitude: 15.9779800)
    var currentLocation: CLLocation?
    var observerUUID: UUID!
    
    var mapWithCircle: MapWithCircleDrawer!
    var longPressHadnler: LongPressHadnler!
    
    override init() {
        super.init()
        
        observerUUID = LocationManager.sharedInstance.add { [weak self] location in
            self?.currentLocation = location.flatMap { $0 }
        
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pretplata"
        
        createMap()
    }
    
    func createMap() {
        let location = currentLocation != nil ? currentLocation! : zagrebLoaction
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.consumesGesturesInView = false
        view = mapView
        
        mapWithCircle = MapWithCircleDrawer(mapView: mapView)
        
        longPressHadnler = LongPressHadnler(minimumPressDuration: 0.6, in: mapView, callback: { [weak self] event in
            guard let strongSelf = self else { return }
            
            switch event {
            case .started:
                let point = strongSelf.longPressHadnler.pressLocation(in: strongSelf.view)
                strongSelf.mapWithCircle.draw(at: point)
            case .ended:
                strongSelf.mapWithCircle.stop()
            }
        })
    }
    
    deinit {
        LocationManager.sharedInstance.removeObserver(for: observerUUID)
    }
    
}
