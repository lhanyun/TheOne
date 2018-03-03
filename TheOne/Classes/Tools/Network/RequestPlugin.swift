//
//  RequestPluginExample.swift
//  MoyaStudy
//
//  Created by fancy on 2017/4/13.
//  Copyright © 2017年 王森. All rights reserved.
//

import Foundation
import Moya
import Result
import MBProgressHUD
import SwiftyJSON

/// show or hide the loading hud

let networkActivityPlugin = NetworkActivityPlugin { change,_ -> () in
    
    switch(change){
        
    case .ended:
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    case .began:
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
}


public final class RequestLoadingPlugin: PluginType {

    var hide:Bool
 
    init(_ hideView:Bool = false) {

        self.hide = hideView
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        
        isFirstTime = true
        
        if !self.hide {
            ZLZKHud.sharedInstance.showLoadingOnView()
        }
       
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
            log.debug("结束请求，解析返回参数：")
            switch result {
            case .success(let response):
                isError = false
                
                let json = JSON(data: response.data)
                
                if json["code"] == 450 {
                    //发送退出通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGOUT), object: nil)
                }
                
                log.debug(json)
                
            case .failure( _):
                isError = true
                TipHUD.sharedInstance.showTips("网络异常，请重新加载")
            }
        
        isFirstTime = false

        ZLZKHud.sharedInstance.hideTips()
        
    }
}

struct AuthPlugin: PluginType {
    let token: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        var request = request
        
        request.timeoutInterval = 30
        request.addValue(token, forHTTPHeaderField: "token")
        request.addValue("ios", forHTTPHeaderField: "platform")
        request.addValue("JSESSIONID="+Tools().userInfo.userSession, forHTTPHeaderField: "Cookie")
        request.addValue("version", forHTTPHeaderField: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        return request
    }
}

//检测token有效性
final class AccessTokenPlugin: PluginType {
    
    private let viewController: UIViewController
    
    init(_ vc: UIViewController) {
        self.viewController = vc
    }

    public func willSend(_ request: RequestType, target: TargetType) {}
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        
        case .success(let response):
        //请求状态码
            guard response.statusCode == 200 else {
                return
            }
            var json:Dictionary? = try! JSONSerialization.jsonObject(with: response.data,
                                                                             options:.allowFragments) as! [String: Any]
            log.debug("请求状态码\(json?["status"] ?? "")")
            
            guard (json?["message"]) != nil  else {
                return
            }
            
            guard let codeString = json?["status"]else {return}
            
            //请求状态为1时候立即返回不弹出任何提示 否则提示后台返回的错误信息
            guard codeString as! Int != 1 else{return}
            
//           self.viewController.view.makeToast( json?["message"] as! String)
            
        case .failure(let error):
            log.debug("出错了\(error)")
            
            break
        }
    }
}
