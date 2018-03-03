
//  AppDelegate.swift
//  TheOne
//
//  Created by lala on 2017/10/29.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ChameleonFramework
import Alamofire
import EaseUI
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //获取主题字典
    var themeDic: [String : String] {
        get {
            guard let themeDic = UserDefaults.standard.dictionary(forKey: CHOOSETHEME) else {
                return ["navColor" : UIColor.flatPlum.hexValue(),
                        "btnColor" : UIColor.flatBlue.hexValue(),
                        "viewColor" : UIColor.flatWhite.hexValue()]
            }
            
            return themeDic as! [String : String]
        }
    }
    
    //APP基础色
    var base_color: UIColor?
    
    //网络监控
    let manager = NetworkReachabilityManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //更换主题通知
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
        
        //设置
        settingAppDelegate()
        
        //即时通信
        EaseSDKHelper.share().hyphenateApplication(application, didReceiveRemoteNotification: launchOptions)
        EaseSDKHelper.share().hyphenateApplication(application, didFinishLaunchingWithOptions: launchOptions, appkey: "tryxmpp#theone", apnsCertName: "", otherConfig: [kSDKConfigEnableConsoleLogger: NSNumber(value: true)])
        
        //绑定代理
        EMClient.shared().add(self, delegateQueue: nil)

        //实例化window
        window = UIWindow()
        window?.backgroundColor = FlatWhite()
        

        window?.makeKeyAndVisible()
  
        //设置 根控制器
        if Tools().userInfo.userLogin == "1" { //已登入
            window?.rootViewController = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateInitialViewController()
        } else { //未登入
            window?.rootViewController = UIStoryboard.init(name: "Login_Register", bundle: Bundle.main).instantiateInitialViewController()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //APP进入后台，断开环信
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        //APP进入前台，重连环信
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    
    fileprivate func settingAppDelegate() {
        
        //键盘设置
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
        IQKeyboardManager.sharedManager().toolbarBarTintColor = FlatGray()
        
        //设置全局主题颜色
        chooseTheme()
        
        //监听网络
        manager?.listener = { status in
            
            switch status {
            case .notReachable:
                log.debug("网络:notReachable")
                haveReachable = false
            case .unknown:
                log.debug("网络:unknown")
                haveReachable = true
            case .reachable(.ethernetOrWiFi):
                log.debug("网络:ethernetOrWiFi")
                haveReachable = true
            case .reachable(.wwan):
                log.debug("网络:wwan")
                haveReachable = true
            }
        }
        manager?.startListening()
        
        //退出通知
        NotificationCenter.default.addObserver(self, selector: #selector(logoutNotificatioin), name: NSNotification.Name(rawValue: LOGOUT), object: nil)
    }
    
    @objc fileprivate func chooseTheme() {
        
        guard let navColor = themeDic["navColor"],
        let btnColor = themeDic["btnColor"],
        let viewColor = themeDic["viewColor"] else {
            return
        }

        //设置全局主题颜色
        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor(hexString:navColor),
                                                  withSecondaryColor: UIColor(hexString:btnColor),
                                                  andContentStyle: .contrast)
        
        base_color = UIColor(hexString:viewColor)
        
    }
    
    @objc func logoutNotificatioin() {
        
        //将用户状态设置为 未登入
        Tools().updataUserInfo(["userLogin": "0", "userSession": ""])
        
        //设置 根控制器
        let storyBoard = UIStoryboard.init(name: "Login_Register", bundle: Bundle.main)
        
        UIApplication.shared.keyWindow?.rootViewController = storyBoard.instantiateInitialViewController()
        
        
        //退出IM
        EMClient.shared().logout(true, completion: { (error) in
            
            error == nil ? log.debug("IM退出成功") : log.debug("IM退出失败")
        })
        
    }
}

//MARK: - EMClientDelegate
extension AppDelegate: EMClientDelegate {
    
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        log.debug("环信自动登入")
    }
    
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        log.debug("掉线重连")
    }
    
    func userAccountDidLoginFromOtherDevice() {
        log.debug("当前账号在其他设备登入")
    }
    
    func userAccountDidRemoveFromServer() {
        log.debug("当前账号已在服务器删除")
    }
    
    func userDidForbidByServer() {
        log.debug("账号被服务器禁用")
    }
    
    func userAccountDidForced(toLogout aError: EMError!) {
        log.debug("当前账号被强制退出，密码修改或登入设备过多")
    }
}

