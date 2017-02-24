import UIKit

class NumberInputCellPresentable {
    let title: String
    var inputViewNumber: Int
    let inputViewDidChange: (Int) -> Void
    
    init(title: String, inputViewNumber: Int, inputViewDidChange: @escaping (Int) -> Void) {
        self.title = title
        self.inputViewNumber = inputViewNumber
        self.inputViewDidChange = inputViewDidChange
    }
}

class NumberInputCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var input: UITextField!
    
    var presentable: NumberInputCellPresentable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        present()
    }
    
    func set(presentable: NumberInputCellPresentable) {
        self.presentable = presentable
        
        present()
    }
    
    func present() {
        if let title = title {
            title.text = presentable?.title
            input.text = String(presentable?.inputViewNumber ?? 0)
        }
    }
    
    @IBAction func inputViewChanged(_ sender: Any) {
        if let value = Int(input.text ?? ""), value > 0 {
            presentable?.inputViewDidChange(value)
        } else {
            input.text = String(presentable?.inputViewNumber ?? 0)
        }
    }
    
}
