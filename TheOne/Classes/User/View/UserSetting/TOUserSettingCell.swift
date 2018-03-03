//
//  TOUserSettingCell.swift
//  TheOne
//
//  Created by lala on 2018/1/8.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOUserSettingCell: TOTableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
