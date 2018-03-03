//
//  TONavigationController.swift
//  TheOne
//
//  Created by lala on 2017/10/29.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import EaseUI

class TONavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isHidden = true
    }

    @objc fileprivate func popVC() {
        popViewController(animated: true)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //判断是否是TOBaseViewController的子控制器
        if let vc = viewController as? TOBaseViewController {
            
            if childViewControllers.count > 0 {
                
                var title = ""
                
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.navigationItem.title ?? ""
                    //隐藏tabBar
                    viewController.hidesBottomBarWhenPushed = true
                }
           
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, selector: #selector(popVC), target: self, isBack: true)
                
            }
            
        }
        
        //判断是否是进入聊天相关页
        if let vc = viewController as? EaseRefreshTableViewController {
            
            if childViewControllers.count > 0 {
                
                var title = ""
                
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.navigationItem.title ?? ""
                    //隐藏tabBar
                    viewController.hidesBottomBarWhenPushed = true
                }
                
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, selector: #selector(popVC), target: self, isBack: true)
                
            }
            
        }

        super.pushViewController(viewController, animated: true)
        
    }
    
    

}
