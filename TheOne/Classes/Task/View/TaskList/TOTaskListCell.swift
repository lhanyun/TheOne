//
//  TOTaskListCell.swift
//  TheOne
//
//  Created by lala on 2017/12/8.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import pop

class TOTaskListCell: TOTableViewCell {

    @IBOutlet weak var taskContent: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var cutoffTime: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var taskId: UILabel!
    
    @IBOutlet weak var progressView: ProgressLine!
    
    @IBOutlet weak var priority: UILabel!
    
    var model: TaskListModel? {
        didSet {
            
            taskContent.text = model?.taskContent
            
            switch model?.status {
            case "1"?:
                status.text = "完成"
            case "2"?:
                status.text = "进行中"
            case "3"?:
                status.text = "暂停"
            case "4"?:
                status.text = "被激活"
            case "5"?:
                status.text = "待审批"
            case "6"?:
                status.text = "已关闭"
            default: ()
            }
            
            cutoffTime.text = model?.cutoffTime
            startTime.text = model?.startTime
            taskId.text = model?.taskId
            priority.text = model?.priority
            
            //进度条设置
            let total = Tools().getDifferenceByDate((model?.startTime)!, (model?.cutoffTime)!)
            
            let today = Tools().getDifferenceByDateWithToday((model?.startTime)!)
            
            progressView.progress = CGFloat(today)/CGFloat(total)
            
            if model?.postpone == "0" {
                progressView.layer.pop_removeAllAnimations()
                progressView.layer.opacity = 1
            } else {
                layerAnimation()
            }
            
            switch model?.priority {
            case "1"?:
                priority.backgroundColor = UIColor.flatRed
            case "2"?:
                priority.backgroundColor = UIColor.flatYellow
            case "3"?:
                priority.backgroundColor = UIColor.flatBlue
            case "4"?:
                priority.backgroundColor = UIColor.flatGreen
            default: ()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priority.layer.cornerRadius = priority.frame.size.width/2
        priority.layer.masksToBounds = true
    }
    
}

extension TOTaskListCell {
    
    func setViewCornerRadius(_ view: UIView) {
        
        // 设置圆角
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, cornerRadius: 8)
        let maskLayer = CAShapeLayer.init()
        
        //设置大小
        maskLayer.frame = view.bounds;
        //设置图形样子
        maskLayer.path = maskPath.cgPath;
        view.layer.mask = maskLayer;
        
    }
    
    func layerAnimation() {
        //闪烁动画
        let layerScaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        
        layerScaleAnimation?.duration = 1
        layerScaleAnimation?.fromValue = NSNumber(value: 1.0)
        layerScaleAnimation?.toValue = NSNumber(value: 0.3)
        layerScaleAnimation?.repeatCount = Int.max
        progressView.layer.pop_add(layerScaleAnimation, forKey: "kPOPLayerOpacity")
    }
    
}
