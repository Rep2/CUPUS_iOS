import UIKit
import GoogleMaps

class SubscriberViewController: BaseViewController {
    
    let zagrebLoaction = CLLocation(latitude: 45.8144400, longitude: 15.9779800)
    var currentLocation: CLLocation?
    var observerUUID: UUID!
    
    var mapWithCircle: MapWithCircleDrawer!
    var longPressHadnler: LongPressHadnler!
    
    lazy var plusButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Plus"), style: .plain, target: self, action: #selector(SubscriberViewController.plusPressed))
    }()
    
    lazy var cancleButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Cancle"), style: .plain, target: self, action: #selector(SubscriberViewController.canclePressed))
    }()
    
    lazy var rightArrowButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "RightArrow"), style: .plain, target: self, action: #selector(SubscriberViewController.areaSelected))
    }()
    
    lazy var subscriptionListButton: UIBarButtonItem = {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: .plain, target: self, action: #selector(SubscriberViewController.subscriptionListSelected))
    }()
    
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
        
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = subscriptionListButton
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
                if strongSelf.mapWithCircle.circle != nil {
                    strongSelf.navigationItem.rightBarButtonItems = [strongSelf.cancleButton, strongSelf.rightArrowButton]
                }
                
                strongSelf.mapWithCircle.stop()
            }
        })
    }
    
    func plusPressed() {
        presentAlert(title: "Odaberite tip pretplate", actions: [
            UIAlertAction(title: "Follow", style: .default, handler: { _ in
                self.pushNewSubscription(state: .follow)
            }),
            UIAlertAction(title: "Pick", style: .default, handler: { _ in
                self.longPressHadnler.set(enabled: true)
                
                self.navigationItem.rightBarButtonItems = [self.cancleButton]
            }),
            UIAlertAction(title: "Odustani", style: .cancel),
            ])
    }
    
    func canclePressed() {
        longPressHadnler.set(enabled: false)
        
        navigationItem.rightBarButtonItems = [plusButton]
        
        mapWithCircle.deleteCircle()
    }
    
    func areaSelected() {
        pushNewSubscription(state: .pick)
    }
    
    func pushNewSubscription(state: NewSubscriptionState) {
        let (_, viewController) = NewSubscriptionPresenter.create(state: state, callback: newSubscription)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func newSubscription(newSubscriptionTypes: NewSubscriptionPresentable, radious: NumberInputCellPresentable?) {
        let circle: GMSCircle
        
        if let radious = radious {
            let location = currentLocation != nil ? currentLocation! : zagrebLoaction
            circle = GMSCircle(position: location.coordinate, radius: Double(radious.inputViewNumber))
        } else if let mapCircle = mapWithCircle.circle {
            circle = mapCircle
        } else {
            fatalError("Failed to create subscription")
        }
        
        let types = newSubscriptionTypes.subscriptionTypes.filter { $0.selected }.map { $0.title }
        let subscription = Subscription(state: radious != nil ? .follow : .pick, subscriptionTypes: types, circle: circle)
        
        SubscriptionList.sharedInstance.add(subscription: subscription)
    }
    
    func subscriptionListSelected() {
        
    }
    
    deinit {
        LocationManager.sharedInstance.removeObserver(for: observerUUID)
    }
    
}
