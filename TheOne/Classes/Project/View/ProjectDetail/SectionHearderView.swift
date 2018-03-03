//
//  SectionHearderView.swift
//  TheOne
//
//  Created by lala on 2017/11/21.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SectionHearderView: UIControl {

    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var iconLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            
            if !isSelected {
                guard let arrowLeft = FAKIonIcons.iosArrowLeftIcon(withSize: 20) else {
                    return
                }
                iconLabel.attributedText = arrowLeft.attributedString()
            } else {
                guard let arrowLeft = FAKIonIcons.iosArrowDownIcon(withSize: 20) else {
                    return
                }
                iconLabel.attributedText = arrowLeft.attributedString()
            }
            
        }
    }
    
    
    class func hearderView() -> SectionHearderView {
        
        let nib = UINib(nibName: "SectionHearderView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! SectionHearderView

        //设置大小  xib默认是600*600
        v.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 44)
        
        guard let arrowLeft = FAKIonIcons.iosArrowLeftIcon(withSize: 20) else {
            return v
        }
        
        v.iconLabel.attributedText = arrowLeft.attributedString()
        
        return v
    }

}
