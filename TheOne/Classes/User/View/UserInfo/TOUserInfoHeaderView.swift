//
//  TOUserInfoHeaderView.swift
//  TheOne
//
//  Created by lala on 2018/1/8.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

/* index:0 跳转到usersetting页面、 index:1 更换头像 */
typealias userInfoHeaderBlock = (_ index: Int) -> Void
class TOUserInfoHeaderView: UIView {
    
    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var module: UILabel!
    @IBOutlet weak var name: UILabel!
    //回调 闭包
    var postValueBlock:userInfoHeaderBlock?

    class func userInfoHeaderView() -> TOUserInfoHeaderView {
        
        let nib = UINib(nibName: "TOUserInfoHeaderView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TOUserInfoHeaderView
        
        v.backgroundColor = BASE_COLOR
        
        //设置大小  xib默认是600*600
        v.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 44)
        
        let imgSize = CGSize(width: 20, height: 20)
        
        let img = FAKFontAwesome.userCircleOIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        
        v.headerImg.cz_setImage(urlString: Tools().userInfo.userIcon, placeholderImage: img, isAvatar: true)
        
        v.name.text = Tools().userInfo.userName
        v.module.text = Tools().userInfo.userModule
        
        return v
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let postValueBlock = self.postValueBlock else { return }
        postValueBlock(0)
    }
    
    //更新头像
    @IBAction func changeHeaderImg(_ sender: UITapGestureRecognizer) {
        guard let postValueBlock = self.postValueBlock else { return }
        postValueBlock(1)
    }

}
