//
//  TOProjectDetailTableViewCell.swift
//  TheOne
//
//  Created by lala on 2017/11/18.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TOProjectDetailTableViewCell: TOTableViewCell {

    
    @IBOutlet weak var rightView: UITextField!
    
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
