//
//  ZLZKRefreshView.swift
//  swift02
//
//  Created by lala on 2017/4/28.
//  Copyright © 2017年 lala. All rights reserved.
//

import UIKit

class ZLZKRefreshView: UIView {

    /// 刷新状态
    var refreshState: ZLZKRefreshState = .Normal {
        didSet {
            switch refreshState {
                
            case .Normal:
                tipLabel.text = "继续使劲拉..."
                tipIcon.isHidden = false
                
                //隐藏菊花
                indicator.stopAnimating()
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon.transform = CGAffineTransform.identity
                })
                tipIcon.transform.inverted()
                
            case .Pulling:
                tipLabel.text = "放手就刷新..."
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(.pi + 0.001)) //加0.001是为了触发动画的就近复位原则
                })
            case .WillRefresh:
                tipLabel.text = "正在刷新..."
                
                tipIcon.isHidden = true
                
                //显示菊花
                indicator.startAnimating()
                
            }

        }
    }
    
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    var iii:CGFloat = 30
    
    class func refreshView() -> ZLZKRefreshView {
        
        let nib = UINib(nibName: "ZLZKRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! ZLZKRefreshView
        
    }
}
