//
//  ViewController.swift
//  UsefulExtensions
//
//  Created by Артём Зиньков on 9/11/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel! {
        didSet {
            recursiveAnimation()
        }
    }
    
    private func recursiveAnimation() {
        Timer(fire: Date(), interval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0) { /// .repeat option - just capture execution and animate if same time over and over (no repeated execution on `animation` block
                    guard let self = self else { return }
                    self.label.transform = CGAffineTransform(scaleX: .random(in: 1...2), y: .random(in: 1...2))
                    self.label.layer.applying {
                        $0.backgroundColor = UIColor.randomColor.cgColor
                        let smallerSide = min($0.frame.width, $0.frame.height)
                        $0.cornerRadius = .random(in: 0...smallerSide / 2)
                    }
                }
            }
        }.applying {
            RunLoop.main.add($0, forMode: .default)
        }
    }
}

class MyCustomTVC: UITableViewCell {}
