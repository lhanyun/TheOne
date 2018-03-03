//
//  TOMemberCell.swift
//  TheOne
//
//  Created by lala on 2017/11/21.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

class TOMemberCell: TOTableViewCell {
    
    var isShowRole: Bool = true {
        didSet {
            userRole.isHidden = !isShowRole
        }
    }
    
    var model:UserInfo? {
        didSet {
            
            let imgSize = CGSize(width: 20, height: 20);
            
            let taskImg = FAKFontAwesome.userCircleOIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
            
            headerImg.cz_setImage(urlString: model?.userIcon, placeholderImage: taskImg, isAvatar: true)
            
            userName.text = model?.userName
            nickName.text = model?.userNickName
            
            userRole.text = model?.userRole.count == 0 ? "请设置成员角色" : model?.userRole
        }
    }

    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var userRole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
