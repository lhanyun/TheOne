//
//  JBWComposePictureViewCell.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/7/10.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit

class JBWComposePictureViewCell: UICollectionViewCell {
    
    //删除指定图片
    var closure:(()->())?
    
    //定义一个属性
    var image: UIImage?{
        didSet{
            
            //正常图片
            if let i = image {
                bgImageView.image = i
                bgImageView.highlightedImage = nil
            } else {
                //加号图片
                bgImageView.image = UIImage(named: "compose_pic_add")
                bgImageView.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
            }
            
            //是否显示删除按钮
            deleteButton.isHidden = (image == nil)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //删除按钮方法
    @objc private func deleteClick(){
        closure?()
    }
    private func setupUI(){
        backgroundColor = UIColor.white
        
        //添加控件
        contentView.addSubview(bgImageView)
        contentView.addSubview(deleteButton)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        deleteButton.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
        }
    }
    
    //懒加载控件
    //背景图片
    private lazy var bgImageView: UIImageView = UIImageView()
    //删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        //监听事件
        button.addTarget(self, action: #selector(deleteClick), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "compose_photo_close"), for: UIControlState.normal)
        return button
        
    }()
}
