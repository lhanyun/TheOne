//
//  TOTableViewCell.swift
//  TheOne
//
//  Created by lala on 2017/11/15.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import Reusable

class TOTableViewCell: UITableViewCell, NibReusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = BASE_COLOR
        
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
    }

    @objc fileprivate func chooseTheme() {
        backgroundColor = BASE_COLOR
    }

}
