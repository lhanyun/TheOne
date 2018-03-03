//
//  ZLZKHud.swift
//  Swift_Equipment
//
//  Created by lala on 2017/5/4.
//  Copyright © 2017年 lala. All rights reserved.
//

import UIKit

class ZLZKHud: UIView {

    //单例  闭包
    static let sharedInstance:ZLZKHud = {
        
        let instance = ZLZKHud()
        
        instance.backgroundColor = UIColor.clear
        
        return instance;
    }()
    
    func showLoadingOnView() {
        
        let window = UIApplication.shared.keyWindow
        
        frame = UIScreen.main.bounds
        
 
        let loadView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loadView.center = center

        let layer = YUReplicatorAnimation.replicatorLayer_Triangle()
        
        loadView.layer.addSublayer(layer!)

//        let load = YULoadingLabel(frame: CGRect(x: -10, y: 55, width: 80, height: 20))
//        load.showLoading(in: loadView, text: nil)

        addSubview(loadView)
        window?.addSubview(self)
        
    }

    
    func showTips(str: String?) {
        
        guard let str = str else {
            return
        }
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        
        let label = UILabel()
        
        label.numberOfLines = 0;
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        
        label.text = str;
            
        let size = self.sizeWithString(string: label.text!, font: label.font)

        //给 self 设置大小
        frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height + 20)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        center = (window?.center)!

        // 创建毛玻璃视图
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = bounds
        addSubview(effectView)
        
        label.textAlignment = .center
        label.frame = bounds
        addSubview(label)
        
        // 隐藏动画
        UIView.animate(withDuration: displayDurationForString(string: str), animations: {
            self.alpha = 0
        }) { (_) in
            self.hideTips()
        }
   
    }
    
    // 隐藏
    func hideTips() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        alpha = 1
        
        removeFromSuperview()
        
    }
    

    fileprivate func sizeWithString(string: String, font: UIFont) -> CGSize {
        
        let viewSize = CGSize(width: 200, height: 8000)
        
        let rect = (string as NSString).boundingRect(with: viewSize, options: [.truncatesLastVisibleLine, .usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)

        return rect.size
        
    }
    
    //显示时间
    fileprivate func displayDurationForString(string: String) -> TimeInterval {
        
        if Double(string.count)*0.08 < 1.00 {
            return 1.00
        } else {
            return Double(string.count)*0.08
        }
        
    }
    
               

}
