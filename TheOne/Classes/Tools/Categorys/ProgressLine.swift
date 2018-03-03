//
//  ProgressLine.swift
//  TheOne
//
//  Created by lala on 2017/11/20.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework

class ProgressLine: UIView {

    var progress:CGFloat = 0.0 {
        didSet {
            //更新UI
            setNeedsDisplay()
        }
    }
    
    var widthS:Float = 0.0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5.0
        layer.masksToBounds = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = GradientColor(.leftToRight, frame: frame, colors: [FlatGreen(),FlatRed()])
    }
  
    override func draw(_ rect: CGRect) {
        
        //获得处理的上下文
        let context = UIGraphicsGetCurrentContext()
        
        //指定直线样式
        context?.setLineCap(.square)

        //直线宽度
        context?.setLineWidth(frame.height)
        
        //设置颜色
        context?.setStrokeColor(FlatGray().cgColor)
        
        //开始绘制
        context?.beginPath()
        
        //画笔移动到点
        context?.move(to: CGPoint(x: 0, y: 5))
        
        //下一点
        context?.addLine(to: CGPoint(x: progress*frame.width, y: 5.0))

        //绘制完成
        context?.strokePath()
        
    }
   

}
