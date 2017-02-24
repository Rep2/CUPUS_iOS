import UIKit

enum NewSubscriptionState {
    case follow
    case pick
    
    var numbeOfSections: Int {
        switch self {
        case .follow:
            return 3
        case .pick:
            return 2
        }
    }
}

class NewSubscriptionPresenter: NSObject {
    
    weak var tableViewController: TableViewController?
    var presentable = NewSubscriptionPresentable.mock
    
    let state: NewSubscriptionState
    
    var radiousPresentable: NumberInputCellPresentable!
    
    var callback: (NewSubscriptionPresentable, NumberInputCellPresentable?) -> Void
    
    init(state: NewSubscriptionState, callback: @escaping (NewSubscriptionPresentable, NumberInputCellPresentable?) -> Void) {
        self.state = state
        self.callback = callback
        
        super.init()
        
        radiousPresentable = NumberInputCellPresentable(title: "Radius pretplate u metrima", inputViewNumber: 100, inputViewDidChange: radiousChanged)
    }
    
    static func create(state: NewSubscriptionState, callback: @escaping (NewSubscriptionPresentable, NumberInputCellPresentable?) -> Void) -> (NewSubscriptionPresenter, TableViewController) {
        let presenter = NewSubscriptionPresenter(state: state, callback: callback)
        let tableViewController = TableViewController(delegate: presenter)
        
        presenter.tableViewController = tableViewController
        
        return (presenter, tableViewController)
    }
    
    func radiousChanged(value: Int) {
        radiousPresentable.inputViewNumber = value
    }
    
}

extension NewSubscriptionPresenter: TableViewDelegate {
    func viewDidLoad() {
        tableViewController?.tableView.register(UINib(nibName: BasicCell.identifier, bundle: nil), forCellReuseIdentifier: BasicCell.identifier)
        tableViewController?.tableView.register(UINib(nibName: ButtonCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonCell.identifier)
        tableViewController?.tableView.register(UINib(nibName: NumberInputCell.identifier, bundle: nil), forCellReuseIdentifier: NumberInputCell.identifier)
        
        tableViewController?.title = "Odabir pretplate"
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewSubscriptionPresenter.backgroundPressed))
        gestureRecognizer.cancelsTouchesInView = false
        tableViewController?.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func backgroundPressed() {
        if case state = NewSubscriptionState.follow, let cell = tableViewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NumberInputCell {
            cell.input.resignFirstResponder()
        }
    }
    
    func savePressed() {
        let slectedTypes = presentable.subscriptionTypes.filter { $0.selected }
        
        if slectedTypes.count == 0 {
            tableViewController?.presentAlert(title: "Odaberite barem jedan tip pretplate", actions: [
                    UIAlertAction(title: "OK", style: .cancel, handler: nil)
                ])
        } else {
            callback(presentable, state == .follow ? radiousPresentable : nil)
        }
    }
}

extension NewSubscriptionPresenter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .follow:
            switch indexPath.section {
            case 1:
                let selected = !presentable.subscriptionTypes[indexPath.row].selected
                presentable.subscriptionTypes[indexPath.row].selected = selected
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = selected ? .checkmark : .none
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            case 2:
                savePressed()
            default:
                break
            }
        case .pick:
            switch indexPath.section {
            case 0:
                let selected = !presentable.subscriptionTypes[indexPath.row].selected
                presentable.subscriptionTypes[indexPath.row].selected = selected
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = selected ? .checkmark : .none
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            case 1:
                savePressed()
            default:
                break
            }
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch state {
        case .follow:
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: NumberInputCell.identifier, for: indexPath)
                
                if let cell = cell as? NumberInputCell {
                    cell.set(presentable: radiousPresentable)
                }
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.identifier, for: indexPath)
                
                if let cell = cell as? BasicCell {
                    cell.set(presentable: presentable.subscriptionTypes[indexPath.row])
                }
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath)
                
                if let cell = cell as? ButtonCell {
                    cell.set(presentable: "Spremi")
                }
            }
        case .pick:
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.identifier, for: indexPath)
                
                if let cell = cell as? BasicCell {
                    cell.set(presentable: presentable.subscriptionTypes[indexPath.row])
                }
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath)
                
                if let cell = cell as? ButtonCell {
                    cell.set(presentable: "Spremi")
                }
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .follow:
            switch section {
            case 0:
                return 1
            case 1:
                return presentable.subscriptionTypes.count
            default:
                return 1
            }
        case .pick:
            switch section {
            case 0:
               return presentable.subscriptionTypes.count
            default:
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return state.numbeOfSections
    }
}
