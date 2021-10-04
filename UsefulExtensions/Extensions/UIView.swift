//
//  UIView.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

extension UIView {
    
    private static var kBoundsObserver: UInt8 = 0

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var roundTopLeft: Bool {
        get {
            return layer.maskedCorners.contains(.layerMinXMinYCorner)
        }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }

    @IBInspectable var roundTopRight: Bool {
        get {
            return layer.maskedCorners.contains(.layerMaxXMinYCorner)
        }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }

    @IBInspectable var roundBottomLeft: Bool {
        get {
            return layer.maskedCorners.contains(.layerMinXMaxYCorner)
        }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }

    @IBInspectable var roundBottomRight: Bool {
        get {
            return layer.maskedCorners.contains(.layerMaxXMaxYCorner)
        }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }

    /// Round all corners
    @IBInspectable var roundCorners: Bool {
        get {
            return layer.cornerRadius == layer.bounds.height / 2
        }
        set {
            if newValue {
                layer.cornerRadius = layer.bounds.height / 2
                guard boundsObserver == nil else { return }
                startObservation()
            } else {
                layer.cornerRadius = 0
                boundsObserver = nil
            }
        }
    }

    private var boundsObserver: NSKeyValueObservation? {
        get {
            return objc_getAssociatedObject(self, &UIView.kBoundsObserver) as? NSKeyValueObservation
        }
        set {
            boundsObserver?.invalidate()
            objc_setAssociatedObject(self, &UIView.kBoundsObserver, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private func startObservation() {
        boundsObserver = observe(\.bounds) { capturedSelf, observedChange in
            if let oldBounds = observedChange.oldValue, let newBounds = observedChange.newValue, oldBounds.equalTo(newBounds) {
                return
            }
            capturedSelf.roundCorners = true
        }
    }

    func snapToSuperview(_ insets: UIEdgeInsets = .zero, snapToSafeArea: Bool = false) {
        guard let superview = superview else { return }
        snapTo(superview, insets: insets, snapToSafeArea: snapToSafeArea)
    }

    func snapTo(_ view: UIView, insets: UIEdgeInsets = .zero, snapToSafeArea: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        let parent: AnchorProvider = snapToSafeArea ? view.safeAreaLayoutGuide : view
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insets.left),
            parent.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right),
            topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
            parent.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)])
    }
}

protocol AnchorProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: AnchorProvider {}
extension UILayoutGuide: AnchorProvider {}
