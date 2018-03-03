//
//  TOProjectListCell.swift
//  TheOne
//
//  Created by lala on 2017/11/14.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import pop

class TOProjectListCell: TOTableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var progressView: ProgressLine!
    
    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var projectStatus: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    
    var model:ProjectListModel? {
        didSet {
            
            projectName.text = model?.projectName
            startTime.text = model?.createTime
            endTime.text = model?.endTime
            
            
            //进度条设置
            let total = Tools().getDifferenceByDate((model?.createTime)!, (model?.endTime)!)

            let today = Tools().getDifferenceByDateWithToday((model?.createTime)!)
            
            progressView.progress = CGFloat(today)/CGFloat(total)
            
            
            //项目状态设置
            switch Tools().compareTimeWithToday((model?.endTime)!) {
            case 1:
                projectStatus.text = "正常"
                projectStatus.textColor = UIColor.flatGreen
                progressView.layer.pop_removeAllAnimations()
                progressView.layer.opacity = 1
            case 0:
                projectStatus.text = "今天截止"
                projectStatus.textColor = UIColor.flatRed
                layerAnimation()
            case -1:
                projectStatus.text = "延期"
                projectStatus.textColor = UIColor.flatRed
                layerAnimation()
            default:
                log.debug("时间异常")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

extension TOProjectListCell {
    class func cellHeigh() -> CGFloat {
        
        return 146
    }
    
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


