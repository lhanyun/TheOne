//
//  TOMemberListCell.swift
//  TheOne
//
//  Created by lala on 2017/12/26.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TOMemberListCell: TOTableViewCell {

    var model:UserInfo? {
        didSet {
            
            textLabel?.text = model?.userName
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
