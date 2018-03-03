//
//  ProjectListViewModel.swift
//  TheOne
//
//  Created by lala on 2017/11/14.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import NSObject_Rx


enum TORefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class ProjectListViewModel: NSObject {
    
    // 存放着解析完成的模型数组
    let models = Variable<[ProjectListModel]>([])
    
    // 记录当前的索引值
    var index: Int = -1

}

extension ProjectListViewModel: TOViewModelType {
    
    typealias Input = ProjectListInput
    typealias Output = ProjectListOutput
    
    struct ProjectListInput {
//        // 网络请求类型
//        let category: LXFNetworkTool.LXFNetworkCategory
//
//        init(category: LXFNetworkTool.LXFNetworkCategory) {
//            self.category = category
//        }
    }
    
    struct ProjectListOutput {
        // tableView的sections数据
        let sections: Driver<[ProjectListSection]>
        
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommond = PublishSubject<Bool>()
        
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = Variable<TORefreshStatus>(.none)
        
        init(sections: Driver<[ProjectListSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: ProjectListViewModel.ProjectListInput) -> ProjectListViewModel.ProjectListOutput {
        
        let sections = models.asObservable()
            .map { (models) -> [ProjectListSection] in
            
                // 当models的值被改变时会调用
                return [ProjectListSection(items: models)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let output = ProjectListOutput(sections: sections)
        
        output.requestCommond
            .subscribe(onNext: {[weak self] isReloadData in
                
                self?.index = isReloadData ? 0 : (self?.index)! + 1
                
                providerI.rx.request(.projectList(index: (self?.index)!, limit: limit))
                    .mapObject(ProjectModel.self)
                    .subscribe { [weak self] (event) in
                        
                        switch event {
                        case .success(let model):

                            if model.code == 200 {
                                
                                self?.models.value = isReloadData ? model.data : (self?.models.value ?? []) + model.data
                                
                                output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                                
                                if model.data.count == 0 || model.data.count < limit {
                                    output.refreshStatus.value = .noMoreData
                                }
                            }
                            
                            TipHUD.sharedInstance.showTips(model.codeMsg)

                        case .error(_):

                            output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                            
                            //若数据源为空，重新赋值一次，以触发mj_footer.isAutomaticallyHidden
                            if self?.models.value.count == 0 {
                                self?.models.value =  []
                            }
                            
                        }
                        
                    }
                    .disposed(by: (self?.rx.disposeBag)!)

            })
            .disposed(by: rx.disposeBag)
        
        return output
    }
    
    func deleteListItem(_ index: Int) {
        
        let model:ProjectListModel = models.value[index]
        
        providerI.rx.request(.deleteProject(projectId: model.projectId))
            .mapObject(ProjectModel.self)
            .subscribe { [weak self] (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        self?.models.value.remove(at: index)
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    log.debug(error)
                }
                
            }
            .disposed(by: rx.disposeBag)
        
    }

}
