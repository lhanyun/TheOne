//
//  JBWComposeTextView.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/7/8.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit

class JBWComposeTextView: UITextView {

    //重写font属性
    override var font: UIFont?{
        didSet{
            placeholderLabel.font = font
        }
    }
    
    //站位文字
    var placeholder: String? {
        didSet{
            placeholderLabel.text = placeholder
        }
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置视图
    private func setupUI(){
        backgroundColor = UIColor.white
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(5)
            make.width.equalTo(IPHONE_WIDTH - 10)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
            }
    //注册通知监听textView文字改变
    @objc private func textViewTextChange(){
        //设置文字显示和隐藏
        placeholderLabel.isHidden = self.hasText
    }

    
    //懒加载控件
    //站位文字
    private lazy var placeholderLabel: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textColor = UIColor.lightGray
        return lab
        
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
