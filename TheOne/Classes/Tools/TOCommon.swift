//
//  TOCommon.swift
//  TheOne
//
//  Created by lala on 2017/10/31.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework
import Moya
import XCGLogger


/*----------------网络请求相关设置----------------------*/
/// 显示加载指示器
let provider = MoyaProvider<APIManager>(plugins:[networkActivityPlugin,RequestLoadingPlugin(),AuthPlugin(token: "")])

/// 隐藏加载指示器
let providerI = MoyaProvider<APIManager>(plugins:[networkActivityPlugin,RequestLoadingPlugin(true),AuthPlugin(token: "")])

//网络状态 设置初始状态为true
var haveReachable:Bool = true

/*----------------tableView空白页相关设置----------------------*/
//请求返回error（请求错误、服务器出错...）
var isError:Bool = false

//空白页时，字体图标大小
let fontImgSize:CGFloat = 80.0

//用于有scrollView及其子类的页面，判断是否是第一次进入页面
var isFirstTime:Bool = true

/*----------------UI基础配置----------------------*/
let IPHONE_WIDTH = UIScreen.main.bounds.width

let IPHONE_HEIGHT = UIScreen.main.bounds.height

let StatusBarHeight = UIApplication.shared.statusBarFrame.height

let TabBarHeight = StatusBarHeight > 20 ? 83 :49

let NavibarH = 44.0

var BASE_COLOR: UIColor {
    get{
        return (UIApplication.shared.delegate as! AppDelegate).base_color ?? UIColor.flatWhite
        }
    }

//列表刷新，一页的数量
var limit:Int = 5


/*----------------通知----------------------*/
//切换主题通知
let CHOOSETHEME: String = "ChooseTheme"
//退出登入
let LOGOUT: String = "Logout"
//更改头像
let CHANGEHEADERIMG: String = "ChangeHeaderImg"
//更新用户信息
let UPDATEUSERINFO: String = "UpdateUserInfo"
//下载完成
let DOWNLOADCOMPLETED: String = "DownloadCompleted"

/*----------------登入&注册----------------------*/
//账号长度最小值
let minimalAccountLength = 5
//密码长度最小值
var minimalPaswordLength = 6

/*----------------日志----------------------*/
//let log = XCGLogger.default
#if DEBUG
let log: XCGLogger = {
    // Create a logger object with no destinations
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
    
    // Create a destination for the system console log (via NSLog)
    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
    
    // Optionally set some configuration options
    systemDestination.outputLevel = .debug
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = true
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true
    
    // Add the destination to the logger
    log.add(destination: systemDestination)
    
    log.logAppDetails()
    
    return log
}()
#else
let log: XCGLogger = {
    
    // Create a logger object with no destinations
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
    
    //日志文件地址
    let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                             in: .userDomainMask)[0]
    let logURL = cachePath.appendingPathComponent("log.txt")
    // Create a file log destination
    let fileDestination = FileDestination(writeToFile: logURL,
                                          identifier: "advancedLogger.fileDestination",
                                          shouldAppend: true, appendMarker: "-- Relauched App --")
    
    // Optionally set some configuration options
    fileDestination.outputLevel = .debug
    fileDestination.showLogIdentifier = false
    fileDestination.showFunctionName = true
    fileDestination.showThreadName = true
    fileDestination.showLevel = true
    fileDestination.showFileName = true
    fileDestination.showLineNumber = true
    fileDestination.showDate = true
    
    // Process this destination in the background
    fileDestination.logQueue = XCGLogger.logQueue
    
    // Add the destination to the logger
    log.add(destination: fileDestination)
    
    // Add basic app info, version info etc, to the start of the logs
    log.logAppDetails()
    
    return log
}()
#endif




