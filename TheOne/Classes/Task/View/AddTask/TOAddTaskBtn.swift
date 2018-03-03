//
//  TOAddTaskBtn.swift
//  TheOne
//
//  Created by lala on 2017/12/15.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit


class TOAddTaskBtn: UIButton {

    var btn: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加删除按钮
        btn = UIButton(type: .custom)
        btn?.setImage(UIImage(named: "story_icon_close"), for: .normal)
        btn?.backgroundColor = UIColor.flatBlue
        btn?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        btn?.layer.cornerRadius = 2
        
        addSubview(btn!)
        
        layer.masksToBounds = false
        layer.cornerRadius = 3
        setImage(UIImage(named: "story_publish_icon_voice_on"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置删除按钮位置
        btn?.center = CGPoint(x: frame.width - 5, y: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
