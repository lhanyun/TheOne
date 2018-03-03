//
//  TOChooseMemberCell.swift
//  TheOne
//
//  Created by lala on 2017/11/30.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework

class TOChooseMemberCell: TOTableViewCell {

    var model:UserInfo? {
        didSet {
            
            textLabel?.text = model?.userName
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = UIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let cellSubs = subviews
        for view in cellSubs {
            if view.isKind(of: NSClassFromString("UITableViewCellEditControl")!) {
                for imgView in view.subviews {
                    if imgView.isKind(of: NSClassFromString("UIImageView")!) {
                        imgView.setValue(FlatPlum(), forKey: "tintColor")
                        break
                    }
                }
            }
            
        }
    }
    
}
