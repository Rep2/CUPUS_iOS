import UIKit

/// Presents table view with subscription creation options
class SubscriptionCreationPresenter: NSObject {
    fileprivate weak var tableViewController: TableViewController?
    fileprivate var presentable = SubscriptionCreationPresentable.presentable
    
    fileprivate var subscriptionType: SubscriptionType
    
    private init(subscriptionType: SubscriptionType) {
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
        tableViewController?.tableView.register(UINib(nibName: InputCell.identifier, bundle: nil), forCellReuseIdentifier: InputCell.identifier)
        
        tableViewController?.title = "New subscription"
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SubscriptionCreationPresenter.backgroundPressed))
        gestureRecognizer.cancelsTouchesInView = false
        tableViewController?.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func backgroundPressed() {
        tableViewController?.tableView.endEditing(true)
    }
    
    func savePressed() {
        let slectedTypes = presentable.subscriptionTypes.filter { $0.selected }.map { $0.title }
        let selectedSubscriptionValues = SubscriptionValue.values.filter { slectedTypes.contains($0.printableText) }
        
        if selectedSubscriptionValues.count == 0 {
            tableViewController?.presentAlert(title: "Select at least one subscription type", actions: [
                    UIAlertAction(title: "OK", style: .cancel, handler: nil)
                ])
        } else {
            SubscriptionHandler.sharedInstance.createSubscription(type: subscriptionType, subscriptionValues: selectedSubscriptionValues)
            
            _ = tableViewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func radiusChanged(value: String) -> String {
        var returnValue = value
        
        if case .follow(let radius) = subscriptionType {
            if let value = Int(value), value > 0 {
                subscriptionType = .follow(radiusInMeters: Double(value))
            } else {
                returnValue = String(Int(radius))
            }
        }
        
        return returnValue
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
            cell = tableView.dequeueReusableCell(withIdentifier: InputCell.identifier, for: indexPath)
            
            if let cell = cell as? InputCell {
                cell.set(presentable: InputCellPresentableBasic(title: "Radius of subscription in meters", input: String(Int(radius)), inputViewDidChange: radiusChanged))
            }
        case (.follow, 1), (.pick, 0):
            cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.identifier, for: indexPath)
            
            if let cell = cell as? BasicCell {
                cell.set(presentable: presentable.subscriptionTypes[indexPath.row])
            }
        case (.follow, 2), (.pick, 1):
            cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath)
            
            if let cell = cell as? ButtonCell {
                cell.set(presentable: "Save")
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
