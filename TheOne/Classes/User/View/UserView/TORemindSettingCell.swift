//
//  TORemindSettingCell.swift
//  TheOne
//
//  Created by lala on 2018/1/10.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

typealias remindSettingCell = (_ switch: Bool) -> Void
class TORemindSettingCell: TOTableViewCell {

    //回调 闭包
    var postValueBlock:remindSettingCell?
    
    @IBOutlet weak var chooseBtn: UISwitch!
    @IBOutlet weak var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func chooseBtnAct(_ sender: UISwitch) {
        
        guard let postValueBlock = self.postValueBlock else { return }
        postValueBlock(sender.isOn)
    }
}
