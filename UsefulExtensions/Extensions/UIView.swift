//
//  UIView.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

extension UIView {
    
    open class func chainAnimation(_ animations: [ChainAnimation]) {
        
        if let animation = animations.first {
            if let duration = animation.duration {
                UIView.animate(withDuration: duration, animations: {
                    animation.animation()
                }, completion: { _ in
                    UIView.chainAnimation(animations.dropLast())
                })
            } else { // 'nil' means - we don't animate this action
                animation.animation()
                UIView.chainAnimation(animations.dropLast())
            }
        }
        
        /* PROFIT
         UIView.chainAnimation(
             [.init(0.5, and: { self.label.alpha = 0.0 }),
              .init(nil, and: { self.label.text = "" }),
              .init(0.5, and: { self.label.alpha = 1.0 })
             ]
         )
         
         With regular UIView.animate - this would be a mess of code
         */
    }
    
    open class ChainAnimation {
        var duration: TimeInterval?
        var animation: ()->()
        
        init(_ duration: TimeInterval? = nil, and animation: @escaping ()->()) {
            self.duration = duration
            self.animation = animation
        }
    }
}
