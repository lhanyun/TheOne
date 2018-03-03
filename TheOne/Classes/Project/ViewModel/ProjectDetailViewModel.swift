//
//  ProjectDetailViewModel.swift
//  TheOne
//
//  Created by lala on 2018/1/26.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation

class ProjectDetailViewModel {

    func getData(_ projectDetailVC: TOProjectDetailViewController, _ projectId: String) {
        
        provider.rx.request(.detailProject(projectId:projectId))
            .mapObject(ProjectDetailModel.self)
            .subscribe { (event) in

                switch event {
                case .success(let model):

                    if model.code == 200 {

                        projectDetailVC.model = model.data
                    }

                    TipHUD.sharedInstance.showTips(model.codeMsg)

                case .error(let error):

                    log.debug(error)
                }

            }
            .disposed(by: projectDetailVC.rx.disposeBag)
    }
}
