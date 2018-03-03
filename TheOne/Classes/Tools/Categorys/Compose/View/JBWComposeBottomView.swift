//
//  JBWComposeBottomView.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/7/8.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit
//按钮枚举
enum JBWComposeButtomViewType: Int {
    case picture = 1001
    case mention
    case trend
    case emotion
    case add
}

class JBWComposeBottomView: UIView {

    //第四个按钮
    var emoticonButton: UIButton?
    
    //声明闭包
    var closure:((JBWComposeButtomViewType)->())?
    
    //判断是否是自定义表情键盘
    var isEmoticon: Bool = false{
        didSet{
            //记录图片名字
            let imgName = (isEmoticon == true ? "compose_keyboardbutton_background" : "compose_emoticonbutton_background")
            emoticonButton?.setImage(UIImage(named: imgName), for: UIControlState.normal)
            emoticonButton?.setImage(UIImage(named: "\(imgName)_highlighted"), for: UIControlState.highlighted)
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置视图
    private func setupUI(){
        
        let pictureButton = addChildButton(imgName: "compose_toolbar_picture", type: .picture)
        let mentionButton = addChildButton(imgName: "compose_mentionbutton_background", type: .mention)
        let trendButton = addChildButton(imgName: "compose_trendbutton_background", type: .trend)
         emoticonButton = addChildButton(imgName: "compose_emoticonbutton_background", type: .emotion)
        let addButton = addChildButton(imgName: "compose_add_background", type: .add)
        
        pictureButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(mentionButton)
        }
        
        mentionButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(pictureButton.snp.right)
            make.width.equalTo(trendButton)
        }
        
        trendButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(mentionButton.snp.right)
            make.width.equalTo(emoticonButton!)
        }
        
        emoticonButton!.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(trendButton.snp.right)
            make.width.equalTo(addButton)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(emoticonButton!.snp.right)
        }

    }
}

extension JBWComposeBottomView {
    //创建按钮的公共方法
    fileprivate func addChildButton(imgName: String, type:JBWComposeButtomViewType) -> UIButton{
        
        let button = UIButton()
        button.tag = type.rawValue
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        button.setBackgroundImage(UIImage(named: "compose_toolbar_background"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named: "compose_toolbar_background"), for: UIControlState.highlighted)
        button.setImage(UIImage(named: imgName), for: UIControlState.normal)
        button.setImage(UIImage(named: "\(imgName)_highlighted"), for: UIControlState.highlighted)
        addSubview(button)
        return button
        
    }
}

extension JBWComposeBottomView {
    
    @objc fileprivate func buttonClick(button: UIButton){
       print("按钮点击")
        //执行闭包
        closure?(JBWComposeButtomViewType(rawValue: button.tag)!)
    }
}
