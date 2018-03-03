//
//  TOTaskDailyViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/9.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOTaskDailyViewController: TOBaseViewController {
    
    @IBOutlet weak var textViewTop: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "生成日报"
        
        textViewTop.constant = CGFloat(NavibarH) + StatusBarHeight
        view.viewWithTag(100)?.backgroundColor = UIColor.white
        (view.viewWithTag(100) as! UIButton).setTitleColor(UIColor.flatBlack, for: .normal)
    }

    
    @IBAction func buttonAct(_ sender: UIButton) {
        
        
    }
    
}
