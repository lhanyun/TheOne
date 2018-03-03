//
//  TOMessageViewController.swift
//  TheOne
//
//  Created by lala on 2017/12/25.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import EaseUI
import AVFoundation

class TOMessageViewController: EaseMessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(callOutWithChatter), name: NSNotification.Name(rawValue: KNOTIFICATION_CALL), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(callControllerClose), name: NSNotification.Name(rawValue: KNOTIFICATION_CALL_CLOSE), object: nil)
        
        

    }

    @objc fileprivate func callOutWithChatter() {
        
        
    }

    @objc fileprivate func callControllerClose() {

    }
    
}
