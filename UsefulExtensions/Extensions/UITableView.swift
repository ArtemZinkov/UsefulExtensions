//
//  UITableView.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

extension UITableView {
    
    open func register(cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
        
        /* PROFIT:
         tableView.register(cellClass: MyCustomTVC.self)
         // Instead of
         tableView.register(MyCustomTVC.self, forCellReuseIdentifier: "some uniqueness reuired")
         */
    }
    
    open func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: cellClass.self), for: indexPath) as? T
        
        /* PROFIT:
         if let customCell = tableView.dequeueReusableCell(MyCustomTVC.self, for: indexPath) {}
         // Instead of
         if let customCell = tableView.dequeueReusableCell(withIdentifier: "someUnique ID", for: indexPath) as? MyCustomTVC
         */
    }
}
