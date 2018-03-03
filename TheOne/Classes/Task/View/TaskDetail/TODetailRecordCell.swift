//
//  TODetailRecordCell.swift
//  TheOne
//
//  Created by lala on 2017/12/12.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TODetailRecordCell: TOTableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var redBlock: UIView!
    @IBOutlet weak var lineTop: NSLayoutConstraint!
    
    var model: TaskRecordModel? {
        didSet {
            content.text = model?.content
            time.text = "\(model?.handler ?? "") 于 \(model?.createTime ?? "")"
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        redBlock.layer.cornerRadius = redBlock.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
