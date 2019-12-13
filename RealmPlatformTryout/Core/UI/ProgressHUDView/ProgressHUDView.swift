//
//  ProgressHUD.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 12/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


final class ProgressHUDView: UIView {
    @IBOutlet var popupView: UIView!
    @IBOutlet var effectView: UIVisualEffectView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        popupView.layer.cornerRadius = 20
    }
    
    func set(text: String?) -> Self {
        textLabel.text = text
        return self
    }
    
    func show(_ show: Bool, on vc: UIViewController) {
        func hidden() {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
        }
        
        func shown() {
            self.transform = .identity
            self.alpha = 1
        }
        
        if show && self.superview == nil {
            let root = rootParent(of: vc)
            root.view.addSubview(self)
            self.frame = root.view.bounds
            hidden()
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                shown()
            })
        } else if self.superview != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                hidden()
            }, completion: { finished in
                if finished {
                    self.removeFromSuperview()
                }
            })
        }
    }
}

func rootParent(of vc: UIViewController) -> UIViewController {
    var current = vc.parent ?? vc
    while let next = current.parent {
        current = next
    }
    return current
}
