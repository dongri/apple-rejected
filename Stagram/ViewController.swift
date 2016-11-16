//
//  ViewController.swift
//  Stagram
//
//  Created by Dongri Jin on 4/3/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.viewFrame != nil {
            self.view.frame = appDelegate.viewFrame!
            appDelegate.viewFrame = nil
            self.rotatedViews()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
         selector: #selector(ViewController.rotated(_:)),
         name: NSNotification.Name.UIDeviceOrientationDidChange,
         object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
        name: NSNotification.Name.UIDeviceOrientationDidChange,
        object: nil)
    }
    func rotated(_ notification: Notification) {
        if UI_USER_INTERFACE_IDIOM() != .pad {
            return
        }
        self.rotatedViews()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewFrame = self.view.frame
    }

    func rotatedViews() {
        
    }
}

extension UIView {

    func width() -> CGFloat {
        return self.frame.size.width
    }

    func height() -> CGFloat {
        return self.frame.size.height
    }

    func left() -> CGFloat {
        return self.frame.origin.x
    }
    
    func right() -> CGFloat {
        return self.width() + self.frame.origin.x
    }

    func top() -> CGFloat {
        return self.frame.origin.y
    }

    func bottom() -> CGFloat {
        return self.height() + self.frame.origin.y
    }

}
