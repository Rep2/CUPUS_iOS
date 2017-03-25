import UIKit

class SettingsViewController: UITableViewController {
    
    let cellPresentables = [
        SettingsCellSectionPresentable(title: "General", presentables: [
            SettingsCellPresentable(title: "Server IP", value: SettingsPresenter.sharedInstance.settings.ip, valueUpdatedCallback: { value in
                var sin = sockaddr_in()
                
                if value.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
                    SettingsPresenter.sharedInstance.settings.ip = value
                }
                
                return SettingsPresenter.sharedInstance.settings.ip
            }),
            SettingsCellPresentable(title: "Server port", value: "\(SettingsPresenter.sharedInstance.settings.port)", valueUpdatedCallback: { value in
                if let value = Int32(value), value > 0 && value < 100000 {
                    SettingsPresenter.sharedInstance.settings.port = value
                }
                
                return "\(SettingsPresenter.sharedInstance.settings.port)"
            })
            ]
        ),
        
        SettingsCellSectionPresentable(title: "Publisher", presentables: [
            SettingsCellPresentable(title: "Read period in seconds", value: "\(SettingsPresenter.sharedInstance.settings.readPeriod)", valueUpdatedCallback: { value in
                if let value = Double(value), value > 0 && value < 100000 {
                    SettingsPresenter.sharedInstance.settings.readPeriod = value
                }
                
                return "\(SettingsPresenter.sharedInstance.settings.readPeriod)"
            }),
            SettingsCellPresentable(title: "Send period in seconds", value: "\(SettingsPresenter.sharedInstance.settings.sendPeriod)", valueUpdatedCallback: { value in
                if let value = Double(value), value > 0 && value < 1000000 {
                    SettingsPresenter.sharedInstance.settings.sendPeriod = value
                }
                
                return "\(SettingsPresenter.sharedInstance.settings.sendPeriod)"
            })
            ]
        )
    ]
    
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
        let cell: InputCell = tableView.dequeCell(for: indexPath)
        
        cell.set(presentable: cellPresentables[indexPath.section].presentables[indexPath.row], keyboardType: .decimalPad)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellPresentables[section].presentables.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellPresentables.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellPresentables[section].title
    }
}
