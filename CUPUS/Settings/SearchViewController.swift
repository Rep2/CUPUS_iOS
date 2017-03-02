import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        tableView.register(UINib(nibName: InputCell.identifier, bundle: nil), forCellReuseIdentifier: InputCell.identifier)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.backgroundPressed))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func backgroundPressed() {
        tableView.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InputCell.identifier, for: indexPath)
        
        if let cell = cell as? InputCell {
            let title: String
            let value: String
            let inputDidChangeCallback: (String) -> Void
            
            switch (indexPath.row, indexPath.section) {
            case (0, 0):
                title = "Server IP"
                value = SettingsPresenter.sharedInstance.settingsPresentable.ip
                inputDidChangeCallback = { value in
                    var sin = sockaddr_in()
                    if value.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
                        SettingsPresenter.sharedInstance.settingsPresentable.ip = value
                    } else {
                        cell.input.text = value
                    }
                }
            case (1, 0):
                title = "Server port"
                value = "\(SettingsPresenter.sharedInstance.settingsPresentable.port)"
                inputDidChangeCallback = { value in
                    if let value = Int(value), value > 0 && value < 100000 {
                         SettingsPresenter.sharedInstance.settingsPresentable.port = value
                    } else {
                        cell.input.text = value
                    }
                }
            case (0,1):
                title = "Read period"
                value = "\(SettingsPresenter.sharedInstance.readPeriod)"
                inputDidChangeCallback = { value in
                    if let value = Int(value), value > 0 && value < 100000 {
                        SettingsPresenter.sharedInstance.settingsPresentable.port = value
                    } else {
                        cell.input.text = value
                    }
                }
            case (1,1):
                title = "Send period"
                value = "\(SettingsPresenter.sharedInstance.sendPeriod)"
                inputDidChangeCallback = { value in
                    if let value = Int(value), value > 0 && value < 100000 {
                        SettingsPresenter.sharedInstance.settingsPresentable.port = value
                    } else {
                        cell.input.text = value
                    }
                }
            default:
                fatalError("No data for cell")
            }
            
            cell.set(presentable: InputCellPresentable(title: title, input: value, inputViewDidChange: inputDidChangeCallback))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "General"
        case 1:
            return "Publisher"
        default:
            return ""
        }
    }
}
