import UIKit

class SubscriptionCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var presentable: Subscription?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        present()
    }
    
    func set(presentable: Subscription) {
        self.presentable = presentable
        
        present()
    }
    
    func present() {
        if let title = title, let presentable = presentable {
            title.text = presentable.title
            type.text = presentable.subscriptionTypes.joined(separator: ", ")
            location.text = "\(Int(presentable.circle.radius))m \(Double(presentable.circle.position.latitude).roundTo(places: 3)) lat,\(Double(presentable.circle.position.longitude).roundTo(places: 3)) long"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
    }
    
}
