//
//  FileDownloadViewModel.swift
//  TheOne
//
//  Created by lala on 2018/2/23.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation

class FileDownloadViewModel {
    
    func downloadFile(_ VC: TODownloadViewController) {
        
        provider.rx.request(.downloadFile)
            .mapObject(NormalModel.self)
            .subscribe { (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        
                        
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }
    
    func getProjectFiles(_ VC: TODownloadViewController) {
        
        provider.rx.request(.getProjectFiles(projectId: Tools().userInfo.projectId))
            .mapObject(UpdateFileModel.self)
            .subscribe { (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        
                        VC.model = model
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }
}
