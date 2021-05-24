//
//  DraggableView.swift
//  Test
//
//  Created by Artem Zinkov on 11.03.2020.
//  Copyright © 2020 Artem Zinkov. All rights reserved.
//

import UIKit

class DraggableView: UIView {
    @IBInspectable public var shouldDrag: Bool = true {
        didSet {
            drag.isEnabled = shouldDrag
        }
    }
    @IBInspectable public var shouldStayInBounds: Bool = true
    private lazy var drag = UIPanGestureRecognizer(target: self, action: #selector(dragGesture(_:)))

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        addGestureRecognizer(drag)
    }
    @objc private func dragGesture(_ pan: UIPanGestureRecognizer) {
        superview.map {
            let movedPoint = pan.translation(in: $0)
            pan.setTranslation(.zero, in: $0)
            frame = frame.offsetBy(dx: movedPoint.x, dy: movedPoint.y)

            if shouldStayInBounds {
                var origin = frame.origin
                origin.x = min(max(origin.x, 0), $0.frame.width - frame.width)
                origin.y = min(max(origin.y, 0), $0.frame.height - frame.height)
                frame.origin = origin
            }
        }
    }
}
