import UIKit
import GoogleMaps

class MapWithCircleDrawer {
    
    let mapView: GMSMapView
    
    var circle: GMSCircle!
    var timer: Timer?
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    func draw(at point: CGPoint) {
        let coordinate = mapView.projection.coordinate(for: point)
        
        let width = pow(2, Double(mapView.camera.zoom))
        
        if let circle = circle {
            circle.position = coordinate
            circle.radius = CLLocationDistance(floatLiteral: 1500000/width)
        } else {
            circle = createCircle(coordinate: coordinate, radius: CLLocationDistance(floatLiteral: 1500000/width))
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1/30, repeats: true, block: { _ in
            self.circle.radius = self.circle.radius + (1000000/width)
        })
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func deleteCircle() {
        circle.map = nil
        circle = nil
    }
    
    func set(circle: GMSCircle) {
        self.circle?.map = nil
        
        self.circle = createCircle(coordinate: circle.position, radius: circle.radius)
    }
    
    func createCircle(coordinate: CLLocationCoordinate2D, radius: Double) -> GMSCircle {
        let circle = GMSCircle(position: coordinate, radius: radius)
        
        circle.fillColor =  UIColor(red: 73/255.0, green: 131/255.0, blue: 230/255.0, alpha: 0.3)
        circle.strokeColor = UIColor(red: 73/255.0, green: 131/255.0, blue: 230/255.0, alpha: 0.8)
        circle.strokeWidth = 3
        circle.map = mapView
        
        return circle
    }
}
