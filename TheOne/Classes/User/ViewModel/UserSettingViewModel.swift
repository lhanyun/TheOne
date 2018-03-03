//
//  UserSettingViewModel.swift
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

class UserSettingViewModel: NSObject {
    
    //获取编辑用户角色信息
    func userInfoEdit(projectId: String, index: String, nickName: String, role: String, phoneNum: String, eMail: String, module: String, VC: TOUserSettingViewController) {
        
        provider.rx.request(.userInfoEdit(projectId: projectId, index: index, nickName: nickName, role: role, phoneNum: phoneNum, eMail: eMail, module: module))
            .mapObject(UserSettingModel.self)
            .subscribe { (event) in
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        
                        if index == "0" {
                            VC.role = model.data?.role
                        } else {
                            
                            //更新本地数据
                            Tools().updataUserInfo([
                                "userNickName": nickName,
                                                    "userPhone": phoneNum,
                                                    "userEmail": eMail,
                                                    "userModule": module])
                            
                            //更新用户信息通知
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPDATEUSERINFO), object: nil)
                            VC.navigationController?.popViewController(animated: false)
                        }
                        
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }
}
