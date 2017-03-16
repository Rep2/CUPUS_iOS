import UIKit

protocol InputCellPresentable {
    var title: String { get }
    var input: String { get }
    var inputViewDidChange: (String) -> String { get }
}

struct InputCellPresentableBasic: InputCellPresentable {
    let title: String
    let input: String
    let inputViewDidChange: (String) -> String
}

class InputCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var input: UITextField!
    
    var presentable: InputCellPresentable?
    var keyboardType: UIKeyboardType = .numberPad
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        present()
    }
    
    func set(presentable: InputCellPresentable, keyboardType: UIKeyboardType = .numberPad) {
        self.presentable = presentable
        self.keyboardType = keyboardType
        
        present()
    }
    
    func present() {
        if let title = title {
            title.text = presentable?.title
            
            input.text = presentable?.input
            input.keyboardType = keyboardType
        }
    }
    
    @IBAction func inputViewChanged(_ sender: Any) {
        input.text = presentable?.inputViewDidChange(input.text ?? "")
    }
    
}
