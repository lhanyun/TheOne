//
//  NSObject+Extensions.swift
//  TheOne
//
//  Created by lala on 2017/11/24.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation

extension NSObject {
    
    func opacityForever_Animation(time: CGFloat) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.0)
        animation.autoreverses = true
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = MAXFLOAT
//        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        return animation
    }
    
    func bounce_Animation(time: CGFloat) -> CAKeyframeAnimation {
        
        //放大效果，并回到原位
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(time)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        return bounceAnimation
    }
    
    func rotation(dur: Double, repeatCount:Float = 1000.0) -> CABasicAnimation {
        
//        let rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        
        // 设定旋转角度
        animation.fromValue = NSNumber(value: 0.0) // 起始角度
        animation.toValue = NSNumber(value: 2 * Double.pi) // 终止角度
        
        animation.duration  =  dur
        
        animation.autoreverses = false
        
        animation.isCumulative = false
        
        animation.fillMode = kCAFillModeForwards
        
        animation.repeatCount = repeatCount;
        
        return animation;
    }
    
    
}


