import UIKit

class InputCellPresentable {
    let title: String
    var input: String
    let inputViewDidChange: (String) -> Void
    
    init(title: String, input: String, inputViewDidChange: @escaping (String) -> Void) {
        self.title = title
        self.input = input
        self.inputViewDidChange = inputViewDidChange
    }
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
        presentable?.inputViewDidChange(input.text ?? "")
    }
    
}
