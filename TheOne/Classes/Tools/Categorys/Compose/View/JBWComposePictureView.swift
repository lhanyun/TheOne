//
//  JBWComposePictureView.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/7/10.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit

//设置可重用标识符
private let JBWComposePictureViewCellID = "JBWComposePictureViewCellID"

class JBWComposePictureView: UICollectionView {

    //声明闭包
    var closure:(()->())?
    //实例化一个数组
    lazy var imageList: [UIImage] = [UIImage]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let cellMargin: CGFloat = 5
        let cellWH = (IPHONE_WIDTH - 20 - cellMargin * 2) / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWH, height: cellWH)
        //间距
        flowLayout.minimumLineSpacing = cellMargin
        flowLayout.minimumInteritemSpacing = cellMargin
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //提供外界调用方法
    func addImage(image: UIImage){
        //添加图片到数组
        imageList.append(image)
        //显示配图
        if imageList.count == 1 {
            isHidden = false
        }
        //刷新
        reloadData()
    }
    //设置视图
    private func setupUI(){
       //首次隐藏
        isHidden = true
        backgroundColor = UIColor.white
        dataSource = self
        delegate = self
        register(JBWComposePictureViewCell.self, forCellWithReuseIdentifier: JBWComposePictureViewCellID)
    }
}

//UICollectionViewDataSource
extension JBWComposePictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageList.count
        //判断返回count
        let count = imageList.count
        //如果count==0 或==9  有多少返回多少  反之则+1
        if count == 0 || count == 9 {
            return count
        }
        
        return count + 1
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JBWComposePictureViewCellID, for: indexPath) as! JBWComposePictureViewCell
        
        //赋值
//        cell.image = imageList[indexPath.item]
        //如果count == iten 代表有加号按钮
        if imageList.count == indexPath.item {
            cell.image = nil
        } else {
            cell.image = imageList[indexPath.item]
            
            //实例化闭包和闭包回调
            cell.closure = {[weak self] in
                
                self?.imageList.remove(at: indexPath.item)
                //如果imageList等于0 就要隐藏
                self?.isHidden = (self?.imageList.count == 0)
                self?.reloadData()
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //只有点击加号按钮才打开相册
        if imageList.count == indexPath.item {
            //执行闭包
            closure?()
        }
    }
}
