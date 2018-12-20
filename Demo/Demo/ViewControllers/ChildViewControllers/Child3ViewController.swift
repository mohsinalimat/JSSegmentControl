//
//  Child3ViewController.swift
//  JSSegmentControl-Demo
//
//  Created by Max on 2018/12/20.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class Child3ViewController: UIViewController {

    // MARK:
    @IBOutlet weak var button: UIButton!
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:
    @IBAction func buttonPressed(_ sender: UIButton) {
        let show = ShowViewController()
        self.show(show, sender: sender)
    }
}
