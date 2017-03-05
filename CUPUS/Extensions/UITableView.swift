import UIKit

extension UITableView {
    func dequeCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Identifiable {
        if let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Cell with identifier \(T.identifier) not registerd")
        }
    }
}
