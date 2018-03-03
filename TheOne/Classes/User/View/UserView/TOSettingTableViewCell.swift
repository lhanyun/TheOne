//
//  TOSettingTableViewCell.swift
//  TheOne
//
//  Created by lala on 2017/12/28.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

class TOSettingTableViewCell: TOTableViewCell {

    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var introduction: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        changeHeaderImg()
        
        name.text = Tools().userInfo.userName
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeHeaderImg), name: NSNotification.Name(rawValue: CHANGEHEADERIMG), object: nil)
    }

    @objc fileprivate func changeHeaderImg() {
        
        let imgSize = CGSize(width: 20, height: 20)
        
        let img = FAKFontAwesome.userCircleOIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        
        headerImg.cz_setImage(urlString: Tools().userInfo.userIcon, placeholderImage: img, isAvatar: true)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
