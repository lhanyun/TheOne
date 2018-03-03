//
//  TipsHUD.swift
//  TheOne
//
//  Created by lala on 2017/11/15.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import MBProgressHUD
import ChameleonFramework

class TipHUD:NSObject {
    
    //单例  闭包
    static let sharedInstance:TipHUD = {
        
        let instance = TipHUD()
        
        return instance;
    }()
    
    var hud = MBProgressHUD()
    
}

extension TipHUD {
    
    func showLoadingOnView() {
        
        hud = MBProgressHUD()
        
        hud.center = (UIApplication.shared.keyWindow?.center)!
        UIApplication.shared.keyWindow?.addSubview(hud)
        hud.mode = MBProgressHUDMode.indeterminate
//        hud.layer.text = "加载中"
        hud.labelText = "加载中"
//        hud.bezelView.color = FlatWhite()
        hud.removeFromSuperViewOnHide = true
//        hud.backgroundColor.style = .solidColor //或SolidColor
        hud.show(true)
    }
    
    func showTips(_ str:String) {
        hud.removeFromSuperview()
        
        hud = MBProgressHUD()
        hud.center = (UIApplication.shared.keyWindow?.center)!
        UIApplication.shared.keyWindow?.addSubview(hud)
        
        hud.mode = MBProgressHUDMode.customView
        hud.labelText = str
//        hud.bezelView.color = FlatWhite()
        hud.removeFromSuperViewOnHide = true
//        hud.backgroundView.style = .solidColor //或SolidColor
        hud.show(true)
        
        hud.hide(true, afterDelay: 1)
    }
    
    func hideTips() {
      
        hud.hide(true)
    }
    
}
