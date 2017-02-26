import UIKit

class SubscriptionCreationPresenter: NSObject {
    
    weak var tableViewController: TableViewController?
    var presentable = SubscriptionCreationPresentable.mock
    
    var subscriptionType: SubscriptionType
    
    init(subscriptionType: SubscriptionType) {
        self.subscriptionType = subscriptionType
        super.init()
    }
    
    static func create(subscriptionType: SubscriptionType) -> (SubscriptionCreationPresenter, TableViewController) {
        let presenter = SubscriptionCreationPresenter(subscriptionType: subscriptionType)
        let tableViewController = TableViewController(delegate: presenter)
        
        presenter.tableViewController = tableViewController
        
        return (presenter, tableViewController)
    }
    
}

extension SubscriptionCreationPresenter: TableViewDelegate {
    
    func viewDidLoad() {
        tableViewController?.tableView.register(UINib(nibName: BasicCell.identifier, bundle: nil), forCellReuseIdentifier: BasicCell.identifier)
        tableViewController?.tableView.register(UINib(nibName: ButtonCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonCell.identifier)
        tableViewController?.tableView.register(UINib(nibName: NumberInputCell.identifier, bundle: nil), forCellReuseIdentifier: NumberInputCell.identifier)
        
        tableViewController?.title = "Odabir pretplate"
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SubscriptionCreationPresenter.backgroundPressed))
        gestureRecognizer.cancelsTouchesInView = false
        tableViewController?.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func backgroundPressed() {
        if case .follow = subscriptionType, let cell = tableViewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NumberInputCell {
            cell.input.resignFirstResponder()
        }
    }
    
    func savePressed() {
        let slectedTypes = presentable.subscriptionTypes.filter { $0.selected }.map { $0.title }
        
        if slectedTypes.count == 0 {
            tableViewController?.presentAlert(title: "Odaberite barem jedan tip pretplate", actions: [
                    UIAlertAction(title: "OK", style: .cancel, handler: nil)
                ])
        } else {
            SubscriptionList.sharedInstance.createSubscription(type: subscriptionType, filters: slectedTypes)
            
            _ = tableViewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func radiusChanged(value: Int) {
        if case .follow = subscriptionType {
            subscriptionType = .follow(radiusInMeters: Double(value))
        }
    }
}

// MARK: table view delegate and datasource

extension SubscriptionCreationPresenter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (subscriptionType, indexPath.section) {
        case (.follow, 1), (.pick, 0):
            let selected = !presentable.subscriptionTypes[indexPath.row].selected
            presentable.subscriptionTypes[indexPath.row].selected = selected
            
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = selected ? .checkmark : .none
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        case (.follow, 2), (.pick, 1):
            savePressed()
        default:
            break
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch (subscriptionType, indexPath.section) {
        case (.follow(let radius), 0):
            cell = tableView.dequeueReusableCell(withIdentifier: NumberInputCell.identifier, for: indexPath)
            
            if let cell = cell as? NumberInputCell {
                cell.set(presentable: NumberInputCellPresentable(title: "Radius pretplate u metrima", inputViewNumber: Int(radius), inputViewDidChange: radiusChanged))
            }
        case (.follow, 1), (.pick, 0):
            cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.identifier, for: indexPath)
            
            if let cell = cell as? BasicCell {
                cell.set(presentable: presentable.subscriptionTypes[indexPath.row])
            }
        case (.follow, 2), (.pick, 1):
            cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath)
            
            if let cell = cell as? ButtonCell {
                cell.set(presentable: "Spremi")
            }
        default:
            fatalError("No cell for \(subscriptionType) in section \(indexPath.section)")
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionType.numberOfRows(for: section, presentable: presentable)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subscriptionType.numbeOfSections
    }
}
