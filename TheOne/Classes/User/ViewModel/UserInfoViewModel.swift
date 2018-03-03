//
//  UserInfoViewModel.swift
//  TheOne
//
//  Created by lala on 2018/2/22.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import NSObject_Rx

class UserInfoViewModel: NSObject {
    
    //获取用户信息
    func getUserInfo(VC:TOUserInfoViewController) {
        provider.rx.request(.getUserInfo)
            .mapObject(UserInfoModel.self)
            .subscribe { (event) in
                switch event {
                case .success(let model):
                
                    if model.code == 200 {
                        VC.model = model.data
                    }
                
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                
                case .error(let error):
                    log.debug(error)
                }
            
            }
            .disposed(by: VC.rx.disposeBag)
    }
    
    //获取当前项目的用户信息
    func getUserCurrentInfo(VC: TOPresentProjectDViewController) {
        provider.rx.request(.getUserCurrentInfo(projectId: Tools().userInfo.projectId))
            .mapObject(UserInfoModel.self)
            .subscribe { (event) in
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        VC.model = model.data
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }
}
