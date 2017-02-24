import UIKit

protocol BasicCellPresentable {
    var title: String { get }
}

class BasicCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var title: UILabel!
    
    var presentable: BasicCellPresentable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        present()
    }
    
    func set(presentable: BasicCellPresentable) {
        self.presentable = presentable
        
        present()
    }
    
    func present() {
        if let title = title {
            title.text = presentable?.title
        }
    }
    
}
