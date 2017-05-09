import UIKit
import GoogleMaps

class SubscriberViewController: BaseViewController {

    static var sharedInstance: SubscriberViewController!
    
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

        SubscriberViewController.sharedInstance = self
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

        reloadSubscription()
    }

    func reloadSubscription() {
        DispatchQueue.main.async {
            if let subscription = SubscriptionHandler.sharedInstance.selectedSubscription {
                self.mapWithCircle.set(circle: subscription.circle)

                self.mapWithCircle.removeMarkers()

                subscription.payloads.forEach { self.addMarker(for: $0) }
            } else {
                self.mapWithCircle.deleteCircle()
            }
        }
    }

    func addMarker(for payload: Payload) {
        if let geometry = payload.geometry, case .point(let x, let y) = geometry {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: x, longitude: y))

            if let properties = payload.properties as? [Property] {
                marker.isTappable = true
                marker.snippet = markerSnippet(properties: properties)
            }

            mapWithCircle.add(marker: marker)
        }
    }

    func markerSnippet(properties: [Property]) -> String {
        var snippets = [String]()

        for identifier in SubscriptionValue.identifiers {
            if properties.filter({ $0.key == identifier }).count != 0 {
                if let printableText = SubscriptionValue.printableText[identifier] {
                    snippets.append(printableText)
                }

                if let avg = properties.filter({ $0.key == identifier + "Avg" }).first {
                    snippets.append("Average value: \(avg.value)")
                }

                if let min = properties.filter({ $0.key == identifier + "Min" }).first {
                    snippets.append("Minimum value: \(min.value)")
                }

                if let max = properties.filter({ $0.key == identifier + "Max" }).first {
                    snippets.append("Maximum value: \(max.value)")
                }

                return snippets.joined(separator: ",\n")
            }
        }

        // If no identifier is found fallback
        return properties.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
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
