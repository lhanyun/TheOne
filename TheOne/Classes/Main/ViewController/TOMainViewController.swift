//
//  TOMainViewController.swift
//  TheOne
//
//  Created by lala on 2017/10/31.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

class TOMainViewController: UITabBarController {
    
    //记录上次点击的item
    var indexFlag:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpChlidController()

        //实时通话
        DemoCallManager.shared().mainController = self
    }
    
    deinit {

        log.debug("tabbar控制器销毁")
    }
    
    /*
     portrait ：竖屏  肖像
     landscape ： 横屏  风景画
     
     -使用代码控制设备方向的好处： 可以在需要横屏的时候单独处理
     -设置支持的方向后，当前控制器及其子控制器都会遵循这个方向
     -如果播放视频，通常通过模态（modal）展现
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

//切分代码块，把功能相近的函数放在一个extension中。extension中不能定义属性，只能定义方法
//MARK: - 设置界面
extension TOMainViewController {

    fileprivate func setUpChlidController() {
        
        //创建控制器信息数组
        let array:[[String: String]] = [
            
            ["classStr": "TOTaskViewController", "title": "任务"],
            
            ["classStr": "TOChatViewController", "title": "联系"],
  
            ["classStr": "TOUserViewController", "title": "个人中心"]
            
        ]
        
        var arrayVC:[UIViewController] = [UIViewController]()
        
        for (index, dic) in array.enumerated() {

            arrayVC.append(viewController(dic: dic, imgs: imageArr()[index]))
            
        }
        
        viewControllers = arrayVC
        
    }
    
    //dic中存放控制器的：名称、title、图案
    fileprivate func viewController(dic: [String : String], imgs: [UIImage]) -> UIViewController {
        
        guard let classStr = dic["classStr"],
            let vTitle = dic["title"],
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + classStr) as? TOBaseViewController.Type
            else {
                return UIViewController()
        }
        
        let vc = cls.init()
        
        vc.title = vTitle
        
        //设置tabbar图像
        vc.tabBarItem.image = imgs[0]
        vc.tabBarItem.selectedImage = imgs[1]
        
        let viewVC = TONavigationController(rootViewController: vc)
        
        return viewVC
    }
    
    fileprivate func imageArr() -> [[UIImage]] {
        
        let imgSize = CGSize(width: 20, height: 20);
        
        let taskImg = FAKFontAwesome.envelopeOIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        let taskImg_height = FAKFontAwesome.envelopeOpenIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        
        let chatImg = FAKFontAwesome.commentingOIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        let chatImg_height = FAKFontAwesome.commentsIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        
        let userImg = FAKFontAwesome.addressBookOIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        let userImg_height = FAKFontAwesome.addressCardIcon(withSize: 20).image(with: imgSize) ?? (UIImage(named: "arrow")!)
        
        return [[taskImg, taskImg_height], [chatImg, chatImg_height], [userImg, userImg_height]]
        
    }
    
}

//MARK: - 添加点击item动画
extension TOMainViewController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let index = tabBar.items?.index(of: item) ?? 0
        
        if index != indexFlag {
            
            var arr:[UIView] = []
            for view in tabBar.subviews {
                if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                    arr.append(view)
                }
            }
            
            (arr[index] as UIView).layer.add(bounce_Animation(time: 0.5), forKey: "bounceAnimation")

            indexFlag = index
        }

    }
}

