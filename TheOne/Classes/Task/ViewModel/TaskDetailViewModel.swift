//
//  TaskDetailViewModel.swift
//  TheOne
//
//  Created by lala on 2018/2/5.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation

class TaskDetailViewModel {
    
    func getData(_ taskDetailVC: TOTaskDetailViewController, _ taskId: String) {
        
        provider.rx.request(.detailTask(taskId: taskId))
            .mapObject(TaskDetailModel.self)
            .subscribe { (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        
                        taskDetailVC.model = model.data
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    
                    log.debug(error)
                }
                
            }
            .disposed(by: taskDetailVC.rx.disposeBag)
    }
}
