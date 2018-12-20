//
//  Child1ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/20.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class Child1ViewController: UIViewController {

    // MARK:
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    }
}

extension Child1ViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "Row ---- \(indexPath.row)"
        return cell
    }
}

extension Child1ViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
