//
//  AddItemView.swift
//  TheOne
//
//  Created by lala on 2017/11/22.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AddItemView: UIControl {

    @IBOutlet weak var content: UILabel!
    
    //设置content label的内容
    var contectText:String = "" {
        didSet {
            guard let plusIcon = FAKIonIcons.iosPlusOutlineIcon(withSize: 18) else {
                return
            }
            
            let test = NSMutableAttributedString(string: contectText)
            test.append(plusIcon.attributedString())
            content.attributedText = test
        }
    }
    
    
    class func footerView() -> AddItemView {
        
        let nib = UINib(nibName: "AddItemView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! AddItemView
        
        //设置大小  xib默认是600*600
        v.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 44)
        
        return v
    }
}
