import UIKit
import RxSwift

class SensorsPresenter: NSObject {
    
    weak var tableViewController: TableViewController?

    var isRecording = false
    
    let disposeBag = DisposeBag()
    
    static func create() -> (SensorsPresenter, TableViewController) {
        let presenter = SensorsPresenter()
        let controller = TableViewController(delegate: presenter)
        
        presenter.tableViewController = controller
        
        return (presenter, controller)
    }
    
    func reloadData() {
        tableViewController?.tableView.reloadData()
    }
}

extension SensorsPresenter: TableViewDelegate {
    func viewDidLoad() {
        tableViewController?.tableView.register(UINib(nibName: SensorCell.identifier, bundle: nil), forCellReuseIdentifier: SensorCell.identifier)
        
        tableViewController?.title = "Sensors"
    }
    
    func viewWillAppear() {
        reloadData()
    }
}

extension SensorsPresenter {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            tableViewController?.navigationController?.pushViewController(AudioSensorViewController(nibName: AudioSensorViewController.identifier, bundle: nil), animated: true)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SensorCell = tableView.dequeCell(for: indexPath)

        let details = AudioSensorPresenter.sharedInstance.isRecording ? "Active" : "Not active"
        cell.set(presentable: SensorCellPresentable(title: "Audio sensor", details: details, value: nil))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
