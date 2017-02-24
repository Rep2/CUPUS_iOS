import UIKit

protocol TableViewDelegate: UITableViewDelegate, UITableViewDataSource, ViewController {
    
}

class TableViewController: UITableViewController {
    
    var delegate: TableViewDelegate?
    
    init(delegate: TableViewDelegate) {
        super.init(style: .grouped)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) not implemented")
    }
    
}

extension TableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = delegate
        tableView.dataSource = delegate
        
        delegate?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate?.viewDidAppear()
    }
}
