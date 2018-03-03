//
//  EXT+UIImage.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/6/29.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit

//解决图片拉伸问题
extension UIImage {
    //通过class 修饰类方法
    class func resizableImage(named: String) ->UIImage {
        
        let image = UIImage(named: named)!
        
        //
        let top = image.size.height * 0.5
        let left = image.size.width * 0.5
        let bottom = image.size.height * 0.5
        let right = image.size.width * 0.5
        let edgeInsets = UIEdgeInsetsMake(top, left, bottom, right)
        
        //拉伸图片
        let newImage = image.resizableImage(withCapInsets: edgeInsets)
        return newImage
        
    }
}

extension UIImage {
    //截屏方法
    class func getScreenSnap() -> UIImage? {
        //获取主屏幕内容
        let window = UIApplication.shared.keyWindow!
        //开启上下文
        UIGraphicsBeginImageContext(window.bounds.size)
        //将内容渲染到上下文中
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        //从上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        return image
        
    }
    
    //等比例压缩图片 如果图片宽度大于400 就需要压缩
    func dealImageScale(maxWidth: CGFloat) -> UIImage{
        //获取图片的宽高
        let imageW = self.size.width
        let imageH = self.size.height
        //如果小于maxWidth 直接返回
        if imageW < maxWidth {
            return self
        }
        
        //反之需要等比例压缩
        //计算压缩后的图片高度
        let maxH = (maxWidth * imageH)/imageW
        
        //使用上下文
        //开启上下文
        UIGraphicsBeginImageContext(CGSize(width: maxWidth, height: maxH))
        //将图片渲染到上下文中
        self.draw(in: CGRect(x: 0, y: 0, width: maxWidth, height: maxH))
        //通过上下文获取图片
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        //关闭上下文
        UIGraphicsEndImageContext()
        return result
        
    }
    
}
