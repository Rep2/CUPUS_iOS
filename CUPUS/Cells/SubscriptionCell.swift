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
            title.text = presentable.type.title
            type.text = presentable.subscriptionValues.map { $0.printableText }.joined(separator: ", ")
            location.text = "\(Int(presentable.circle.radius))m (\(Double(presentable.circle.position.latitude).roundTo(places: 2)), \(Double(presentable.circle.position.longitude).roundTo(places: 2)))"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
    }
    
}
