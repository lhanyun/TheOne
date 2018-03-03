//
//  JBWComposeView.swift
//  新浪微博
//
//  Created by 季伯文 on 2017/7/7.
//  Copyright © 2017年 bowen. All rights reserved.
//

import UIKit
import pop

typealias composeViewBlock = () -> Void
class JBWComposeView: UIView {

    //记录父控件
    var targetVC: UIViewController?
    
//    var composeMargin:CGFloat = 0.0
    
    //重置父控制器按钮选择状态
    var postValueBlock:composeViewBlock?
    
    //自定义保存按钮
    lazy var composeButtonList: [JBWComposeButton] = [JBWComposeButton]()
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        layer.masksToBounds = true
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //类方法显示当前的view
    func show(targetVC: TOTaskViewController) {
        alpha = 1.0
        //赋值
        self.targetVC = targetVC
        targetVC.view.addSubview(self)
        
        snp.makeConstraints { (make) in
            
            make.top.equalTo(targetVC.navigationBar.snp.bottom)
            make.right.left.equalTo(targetVC.view)
            make.bottom.equalTo(targetVC.view).offset(TabBarHeight)
            
        }
        
        //6个按钮的弹簧动画
        setupComposeButtonAnim(isUp: true)
    }
    //设置视图
    private func setupUI(){
//       backgroundColor = randomColor()
        
        //添加控件
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addComposeButtons()
    
    }
    //懒加载控件
    //背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage.getScreenSnap()!.applyLightEffect())
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        setupComposeButtonAnim(isUp: false)
        
        //延迟删除当前界面
        UIView.animate(withDuration: 0.5, animations: {
            
            self.alpha = 0
            
            guard let postValueBlock = self.postValueBlock else {return}
            postValueBlock()
            
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func hiddenView() {
        
        setupComposeButtonAnim(isUp: false)
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

extension JBWComposeView {
    //添加composeButton
    fileprivate func addComposeButtons(){
        
        //获取plist模型数组
        let composeList = loadComposePlist()
        //计算按钮的宽和高
        let composeButtonW: CGFloat = 70
        let composeButtonH: CGFloat = 90
        //间距
        let composeMargin = (IPHONE_WIDTH - composeButtonW * 4) / 5
        //循环创建六次
        for (i, composeModel) in composeList.enumerated() {
            //计算行和列索引
            let row = CGFloat(i/4)
            let col = CGFloat(i%4)
            //创建按钮
            let button = JBWComposeButton()
            //添加button标识
            button.tag = i + 1
            //赋值
            button.composeModel = composeModel
            //添加监听事件
            button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
            button.frame = CGRect(x:composeMargin + (composeMargin + composeButtonW)*col, y: (composeMargin + composeButtonH)*row - (composeMargin + composeButtonH)*2, width: composeButtonW, height: composeButtonH)
            
            addSubview(button)
            
            //添加
            composeButtonList.append(button)
            
        }
        
    }
}

extension JBWComposeView {
    
    //监听事件
    @objc fileprivate func buttonClick(composeButton: JBWComposeButton){
        
        //设置动画
        UIView.animate(withDuration: 0.25, animations: { 
            //遍历按钮数组
            for button in self.composeButtonList {
                button.alpha = 0.2
                //点击按钮
                if button == composeButton {
                    //放大
                    composeButton.transform = CGAffineTransform(scaleX: 2, y: 2)
                } else {
                    //缩小
                    button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }
            }

        }) { (_) in
            
            //动画完成恢复原样
            UIView.animate(withDuration: 0.25, animations: { 
                //遍历按钮恢复原状
                for button in self.composeButtonList {
                    button.alpha = 1
                    button.transform = CGAffineTransform.identity
                }

            },completion: { (_) in

                //判断className是否为nil
                guard let className = composeButton.composeModel?.className else {
                    log.debug("plist文件中，没有记录className")
                    return
                }
                //判断是否为nil 且是否可以转成UIViewController.type
                guard let type = NSClassFromString(Bundle.main.nameSpace + "." + className) as? TOBaseViewController.Type else {
                    log.debug("没有此控制器")
                    return
                }
            
                //判断跳转的控制器
                if (composeButton.tag == 1) || (composeButton.tag == 2) {
                    let storyBoard = UIStoryboard.init(name: "Project", bundle: Bundle.main)
                    self.targetVC?.show(storyBoard.instantiateViewController(withIdentifier: className), sender: nil)
                } else {
                    
                    let vc = type.init()
                    
                    if className == "TOMemberViewController" {
                        (vc as! TOMemberViewController).isShowAll = "0"
                    }
                    
                    self.targetVC?.show(vc, sender: nil)
                }
                
                guard let postValueBlock = self.postValueBlock else {return}
                postValueBlock()
            
                self.hiddenView()
            })
    
        }
    }
}
extension JBWComposeView {
    //设置弹簧动画
    fileprivate func setupComposeButtonAnim(isUp: Bool){
        
        var buttonMargin: CGFloat = 250
        //消失动画
        if !isUp {
            buttonMargin = -250
            composeButtonList = composeButtonList.reversed()
        }
        
        //遍历按钮
        for (i, composeButton)in composeButtonList.enumerated(){
            let anSprinng = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            anSprinng?.toValue = CGPoint(x: composeButton.center.x, y: composeButton.center.y + buttonMargin)
            anSprinng?.beginTime = CACurrentMediaTime() + Double(i) * 0.025
            //弹簧系数
            anSprinng?.springBounciness = 10
            composeButton.pop_add(anSprinng, forKey: nil)
        }
    }
}
extension JBWComposeView {
    
    //去取plist文件
    fileprivate func loadComposePlist() -> [JBWComposeModel] {
        //路径
        let file = Bundle.main.path(forResource: "compose.plist", ofType: nil)!
        let plistArray = NSArray(contentsOfFile: file)! as! [[String: String]]
        
        var tempList = [JBWComposeModel]()
        for dic in plistArray {
            let model = JBWComposeModel()
            model.title = dic["title"]
            model.index = dic["index"]
            model.className = dic["className"]
            tempList.append(model)
        }
        
        return tempList
    }
}
