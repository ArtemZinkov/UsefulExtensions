//
//  ViewController.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.chainAnimation(
            [.init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor }),
             .init(0.5, and: { self.label.backgroundColor = .randomColor })
            ]
        )
        
        let tableView = UITableView()
        tableView.register(cellClass: MyCustomTVC.self)
        if let _ = tableView.dequeueReusableCell(MyCustomTVC.self, for: IndexPath(row: 0, section: 0)) {}
    }
}

class MyCustomTVC: UITableViewCell {}
