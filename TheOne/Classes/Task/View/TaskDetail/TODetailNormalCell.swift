//
//  TODetailNormalCell.swift
//  TheOne
//
//  Created by lala on 2017/12/13.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TODetailNormalCell: TOTableViewCell {

    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
