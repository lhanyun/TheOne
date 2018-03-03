//
//  AddProjectViewModel.swift
//  TheOne
//
//  Created by lala on 2018/1/31.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation

class AddProjectViewModel {
    
    func submitProject(_ addProjectVC: TOAddProjectViewController, _ dataSource: [String: Any]) {
        
        if (dataSource["projectName"] as! String).count == 0 || (dataSource["startTime"] as! String).count == 0 || (dataSource["endTime"] as! String).count == 0 {
            
            TipHUD.sharedInstance.showTips("请将参数填写完整")
            return
        }
        
        let i = Tools().compareTime(dataSource["startTime"] as! String, dataSource["endTime"] as! String)
        if i == 1 || i == 2 {
            
            TipHUD.sharedInstance.showTips("请正确选择项目的开始时间及结束时间")
            return
        }
        
        var token:APIManager = .editProject(dic: dataSource)
        
        if (dataSource["projectId"] as! String).count == 0 {
            
            token = .createProject(dic: dataSource)
        }
        
        provider.rx.request(token)
            .mapObject(RegisterModel.self)
            .subscribe { (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProjectList"), object: nil)
                        addProjectVC.navigationController?.popViewController(animated: true)
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    
                    log.debug(error)
                }
            }
            .disposed(by: addProjectVC.rx.disposeBag)
    }
}
