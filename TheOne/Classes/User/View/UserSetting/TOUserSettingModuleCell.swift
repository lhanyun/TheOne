//
//  TOUserSettingModuleCell.swift
//  TheOne
//
//  Created by lala on 2018/2/22.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOUserSettingModuleCell: TOTableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var moduleArr: [String] = [] {
        didSet {
            for view in scrollView.subviews {
                view.removeFromSuperview()
            }
            for (index, title) in moduleArr.enumerated() {
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: (60 + 10) * index, y: 0, width: 60, height: 30)
                btn.tag = index + 1
                btn.setTitle(title, for: .normal)
                btn.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
                scrollView.addSubview(btn)
            }
            
            scrollView.contentSize = CGSize(width: (60 + 10) * moduleArr.count, height: 30)
        }
    }
    
    var module: String? {
        didSet {
            moduleArr.append(module!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    @objc fileprivate func deleteBtn(sender: UIButton) {
        moduleArr.remove(at: sender.tag - 1)
    }
    
}
