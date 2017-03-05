import UIKit

class ButtonCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var title: UILabel!
    
    var presentable: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        present()
    }
    
    func set(presentable: String) {
        self.presentable = presentable
        
        present()
    }
    
    func present() {
        if let title = title {
            title.text = presentable
        }
    }
}
