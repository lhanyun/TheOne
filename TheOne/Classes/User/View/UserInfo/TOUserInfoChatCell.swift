//
//  TOUserInfoChatCell.swift
//  TheOne
//
//  Created by lala on 2018/1/8.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOUserInfoChatCell: TOTableViewCell {
    
    @IBOutlet weak var chatView: TOProjectProgressView!
    
    var model: UserModel? {
        didSet {
            
            guard let taskNorNum = model?.taskNorNum,
                let n = Double(taskNorNum),
                let taskppNum = model?.taskppNum,
                let pp = Double(taskppNum),
                let taskppOverNum = model?.taskppOverNum,
                let ppo = Double(taskppOverNum),
                let taskNorOverNum = model?.taskNorOverNum,
                let no = Double(taskNorOverNum)
                else {
                    log.debug("项目饼形图表未拿到值")
                    return
            }
            chatView.setDataCount(4, value: [n,pp,ppo,no])
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
