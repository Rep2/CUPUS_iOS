import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String? = nil, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actions.forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true)
    }
    
}
