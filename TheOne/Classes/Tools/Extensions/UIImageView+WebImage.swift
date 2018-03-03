//
//  UIImageView+WebImage.swift
//  Swift_WeiBo
//
//  Created by lala on 2017/4/25.
//  Copyright © 2017年 lala. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    /// 隔离 SDWebImage
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: 占位视图
    ///   - isAvatar: 是否是头像
    func cz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        //处理 URL
        guard let urlString = urlString ,
            let url = URL(string: urlString) else {
            // 设置占位
            image = placeholderImage
            
            return
        }
        
        // 由于不知道 sd_setImage 此方法内部有没有再引用 这个方法的闭包，为了避免循环引用 [weak self]
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { [weak self] (image, _, _, _) in
            
            
            // 完成回调 - 对图像进行判断是否是头像
            if isAvatar { // 不用判断image是否为nil，如果image为nil，就不会调一下方法
                
                self?.image = image?.cz_avatarImage(size: self?.bounds.size,backColor: (self?.superview?.backgroundColor) ?? UIColor.flatWhite)
                
            } else {
                
                self?.image = image?.cz_image(size: self?.bounds.size)
                
            }
            
        }
        
        
        
    }
    
}
