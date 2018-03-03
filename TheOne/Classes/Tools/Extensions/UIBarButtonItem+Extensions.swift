//
//  UIBarButtonItem+Extensions.swift
//  Swift_Equipment
//
//  Created by lala on 2017/3/19.
//  Copyright © 2017年 lala. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    
    //便利构造函数  自定义UIBarButtonItem
    convenience init(title: String, fontSize: CGFloat = 16, selector: Selector, target: AnyObject?, isBack: Bool) {
        
        let btn:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), highlightedColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        
        btn.addTarget(target, action: selector, for: .touchUpInside)
        
        if isBack {
            
            //为btn设置图片
            let imgName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imgName), for: .normal)
            btn.setImage(UIImage(named: imgName + "_highlighted"), for: .highlighted)
            
            btn.sizeToFit()
            
        }
        
        
        self.init(customView: btn)
    }
    
}
