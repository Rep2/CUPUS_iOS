import UIKit

struct SensorCellPresentable {
    let title: String
    let details: String
    let value: String?
}

class SensorCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var presentable: SensorCellPresentable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        present()
    }
    
    func set(presentable: SensorCellPresentable) {
        self.presentable = presentable
        
        present()
    }
    
    func present() {
        if let title = title, let presentable = presentable {
            title.text = presentable.title
            details.text = presentable.details
            value.text = presentable.value
        }
    }
}
