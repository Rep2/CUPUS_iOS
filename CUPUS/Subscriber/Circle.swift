import CoreLocation
import GoogleMaps

struct Circle {
    let position: CLLocationCoordinate2D
    let radius: Double
    
    init(position: CLLocationCoordinate2D, radius: Double) {
        self.position = position
        self.radius = radius
    }
    
    init(gmsCircle: GMSCircle) {
        self.position = gmsCircle.position
        self.radius = gmsCircle.radius
    }
}
