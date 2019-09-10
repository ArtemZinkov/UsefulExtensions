//
//  UIColor.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

extension UIColor {
    open class var randomColor: UIColor { return UIColor(red: .random(in: 0..<1),
                                                         green: .random(in: 0..<1),
                                                         blue: .random(in: 0..<1),
                                                         alpha: .random(in: 0..<1)) }
}
