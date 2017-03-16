import UIKit

class SubscriptionListPresenter: NSObject {
    
    weak var tableViewController: TableViewController?
    
    static func create() -> (SubscriptionListPresenter, TableViewController) {
        let presenter = SubscriptionListPresenter()
        let controller = TableViewController(delegate: presenter)
        
        presenter.tableViewController = controller
        
        return (presenter, controller)
    }
}

extension SubscriptionListPresenter: TableViewDelegate {
    func viewDidLoad() {
        tableViewController?.tableView.register(UINib(nibName: SubscriptionCell.identifier, bundle: nil), forCellReuseIdentifier: SubscriptionCell.identifier)
        
        tableViewController?.title = "Subscriptions"
        
        tableViewController?.tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    func viewWillAppear() {
        tableViewController?.tableView.reloadData()
    }
}

extension SubscriptionListPresenter {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndex = SubscriptionHandler.sharedInstance.selectedSubscriptionIndex {
            if selectedIndex != indexPath.row {
                tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
            } else {
                return
            }
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        SubscriptionHandler.sharedInstance.selectSubscription(at: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionCell.identifier, for: indexPath)
        
        if let cell = cell as? SubscriptionCell {
            cell.set(presentable: SubscriptionHandler.sharedInstance.subscriptions[indexPath.row])
            
            if let selectedIndex = SubscriptionHandler.sharedInstance.selectedSubscriptionIndex, selectedIndex == indexPath.row {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubscriptionHandler.sharedInstance.subscriptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            SubscriptionHandler.sharedInstance.removeSubscription(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if SubscriptionHandler.sharedInstance.subscriptions.count > 0 {
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        default:
            break
        }
    }
}
