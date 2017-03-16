import UIKit
import GoogleMaps

class SubscriberViewController: BaseViewController {
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Subscriptions"
        
        createMap()
        
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = subscriptionListButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let subscription = SubscriptionHandler.sharedInstance.selectedSubscription {
            mapWithCircle.set(circle: subscription.circle)
        } else {
            mapWithCircle.deleteCircle()
        }
    }
    
    func createMap() {
        let location = LocationManager.sharedInstance.location.value ?? CLLocation(latitude: 45.8144400, longitude: 15.9779800)
        
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
        presentAlert(title: "Select subscription type", actions: [
            UIAlertAction(title: "Follow", style: .default, handler: { _ in
                self.pushNewSubscription(subscriptionType: .follow(radiusInMeters: 100))
            }),
            UIAlertAction(title: "Pick", style: .default, handler: { _ in
                self.longPressHadnler.set(enabled: true)
                
                self.navigationItem.rightBarButtonItems = [self.cancleButton]
            }),
            UIAlertAction(title: "Cancle", style: .cancel),
            ])
    }
    
    func canclePressed() {
        longPressHadnler.set(enabled: false)
        
        navigationItem.rightBarButtonItems = [plusButton]
        
        if let selectedSubscription = SubscriptionHandler.sharedInstance.selectedSubscription {
            mapWithCircle.set(circle: selectedSubscription.circle)
        } else {
            mapWithCircle.deleteCircle()
        }
    }
    
    func areaSelected() {
        pushNewSubscription(subscriptionType: .pick(circle: Circle(gmsCircle: mapWithCircle.circle)))
        
        canclePressed()
    }
    
    func pushNewSubscription(subscriptionType: SubscriptionType) {
        let (_, viewController) = SubscriptionCreationPresenter.create(subscriptionType: subscriptionType)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func subscriptionListSelected() {
        let (_, viewController) = SubscriptionListPresenter.create()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
