//
//  TOAnimationButton.swift
//  TheOne
//
//  Created by lala on 2017/11/24.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import pop

class TOAnimationButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(scaleToSamll), for: .touchDown)
        addTarget(self, action: #selector(scaleToSamll), for: .touchDragEnter)
        addTarget(self, action: #selector(scaleAnimation), for: .touchUpInside)
        
        addTarget(self, action: #selector(scaleToDefault), for: .touchDragExit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(scaleToSamll), for: .touchDown)
        addTarget(self, action: #selector(scaleAnimation), for: .touchUpInside)
        addTarget(self, action: #selector(scaleToDefault), for: .touchDragExit)
    }
    
    
}

extension TOAnimationButton {
    
    @objc fileprivate func scaleToSamll() {
        
        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.toValue = NSValue(cgSize: CGSize(width: 0.95, height: 0.95))
        layer.pop_add(scaleAnimation, forKey: "layerScaleSmallAnimation")
    }
    
    @objc fileprivate func scaleAnimation() {
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
        scaleAnimation?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        scaleAnimation?.springBounciness = 18
        
        layer.pop_add(scaleAnimation, forKey: "layerScaleSpringAnimation")
    }
    
    
    @objc fileprivate func scaleToDefault() {
        
        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        layer.pop_add(scaleAnimation, forKey: "layerScaleSmallAnimation")
    }
    
}
