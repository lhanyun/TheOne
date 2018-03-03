//
//  JBWComposeButton.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/7/7.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit
import FontAwesomeKit

class JBWComposeButton: UIButton {

    //方便使用属性
    var composeModel: JBWComposeModel? {
        didSet {
            guard let index = composeModel?.index,
                let title = composeModel?.title
                else {
                return
            }
            
            setTitle(title, for: UIControlState.normal)
            
            var img:UIImage? = UIImage()
            let imgSize = CGSize(width: 40, height: 40)
            switch index {
            case "0":
                
                img = FAKIonIcons.iosShuffleIcon(withSize: 40).image(with: imgSize) ?? (UIImage(named: "arrow")!)
            case "1":
                img = FAKIonIcons.iosPaperOutlineIcon(withSize: 40).image(with: imgSize) ?? (UIImage(named: "arrow")!)
            case "2":
                img = FAKIonIcons.iosFolderOutlineIcon(withSize: 40).image(with: imgSize) ?? (UIImage(named: "arrow")!)
            case "3":
                img = FAKIonIcons.iosPeopleOutlineIcon(withSize: 40).image(with: imgSize) ?? (UIImage(named: "arrow")!)
            default:
                img = UIImage(named: "arrow")
            }
            setImage(img, for: UIControlState.normal)

        }
    }
    //去掉六个高亮效果
    override var isHighlighted: Bool {
        get{
            return false
        }
        set {
            //空实现
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
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(UIColor.white, for: UIControlState.normal)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    //重写layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        //imageView
        imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width )
        //titleLabel
        titleLabel?.frame = CGRect(x: 0, y: self.frame.width - 10, width: self.frame.width, height: self.frame.height - self.frame.width)

    }

    
}
