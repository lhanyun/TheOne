//
//  TaskCalendarViewModel.swift
//  TheOne
//
//  Created by lala on 2018/2/23.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import NSObject_Rx

class TaskCalendarViewModel: NSObject {
    
    //获取任务
    func getTaskCalendar(forMe: String, VC: TOTaskCalendarViewController) {
        
        provider.rx.request(.tasklist(index: 0, limit: 10000, projectId: Tools().userInfo.projectId, taskLabel: "0", sort: "0", forMe: forMe, search: ""))
            .mapObject(TaskModel.self)
            .subscribe { (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        VC.models = model.data
                    }
                    
                    TipHUD.sharedInstance.showTips("加载成功")
                    
                case .error(let error):
                    
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }

}
