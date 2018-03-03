//
//  TaskListViewModel.swift
//  TheOne
//
//  Created by lala on 2017/12/8.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import NSObject_Rx

class TaskListViewModel: NSObject {
    
    // 存放着解析完成的模型数组
    let models = Variable<[TaskListModel]>([])
    
    var dataSource = [TaskListModel]()
    
    // 记录当前的索引值
    var index: Int = -1
    
    //记录搜索值
    var search: String = ""
    
}

extension TaskListViewModel: TOViewModelType {
    
    typealias Input = TaskListInput
    typealias Output = TaskListOutput
    
    struct TaskListInput {
        
        let searchText: Observable<String>
        let projectId: String
        let vc: TOTaskViewController
        
        init(text: Observable<String>, projectid: String, targetVC: TOTaskViewController) {
            searchText = text
            projectId = projectid
            vc = targetVC
        }
    }
    
    struct TaskListOutput {
        // tableView的sections数据
        let sections: Driver<[TaskListSection]>
        
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommond = PublishSubject<Bool>()
        
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = Variable<TORefreshStatus>(.none)
       
        init(sections: Driver<[TaskListSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: TaskListViewModel.TaskListInput) -> TaskListViewModel.TaskListOutput {
        
        let sections = models.asObservable()
            .map { (models) -> [TaskListSection] in
                
                // 当models的值被改变时会调用
                return [TaskListSection(items: models)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let output = TaskListOutput(sections: sections)
        
        output.requestCommond
            .subscribe(onNext: {[weak self] isReloadData in
                
                self?.index = isReloadData ? 0 : (self?.index)!+1
                self?.netWorking(output: output, isReloadData: isReloadData, input: input, searchText: self?.search ?? "")
                
            })
            .disposed(by: rx.disposeBag)
        
        input.searchText
            .subscribe(onNext: {[weak self] element in
                
                self?.search = element
                self?.index = 0
                
                if element.count == 0 {
                    self?.models.value = (self?.dataSource)!
                } else {
                    self?.netWorking(output: output, isReloadData: true, input: input, searchText: element)
                }
                
            })
            .disposed(by: rx.disposeBag)
        
        return output
    }
    
    //网络请求
    fileprivate func netWorking(output: TaskListOutput, isReloadData: Bool, input: TaskListInput, searchText: String) {
        
        provider.rx.request(.tasklist(index: index, limit: limit, projectId: input.projectId, taskLabel: "\(input.vc.labelIndex)", sort: "\(input.vc.sortIndex)", forMe: "\(input.vc.forMeIndex)", search: searchText))
            .mapObject(TaskModel.self)
            .subscribe { [weak self] (event) in
                
                switch event {
                case .success(let model):
                    
                    self?.models.value = isReloadData ? model.data : (self?.models.value ?? []) + model.data
                    
                    if searchText.count == 0 {
                        self?.dataSource = isReloadData ? model.data : (self?.dataSource ?? []) + model.data
                    }

                    output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                    
                    if model.data.count == 0 || model.data.count < limit {
                        output.refreshStatus.value = .noMoreData
                    } else {
                        output.refreshStatus.value = .endFooterRefresh
                    }
                    
                    TipHUD.sharedInstance.showTips("加载成功")
                    
                case .error(_):
                    
                    output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                    
                    //若数据源为空，重新赋值一次，以触发mj_footer.isAutomaticallyHidden
                    if self?.models.value.count == 0 {
                        self?.models.value =  []
                    }
                    
                }
                
            }
            .disposed(by: rx.disposeBag)
    }
    
    //更新task状态
    func chooseTaskStatus(taskId: String, status: String, VC:TOBaseViewController) {
        
        provider.rx.request(.chooseTaskStatus(taskId: taskId, status: status))
            .mapObject(NormalModel.self)
            .subscribe { (event) in
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshTaskList"), object: nil)
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }
    
    //点赞
    func doPraise(taskId: String, projectId: String, praise: String, userName: String, VC:TOBaseViewController) {
        
        provider.rx.request(.doPraise(taskId: taskId, projectId: projectId, userName: userName, praise: praise))
            .mapObject(NormalModel.self)
            .subscribe { (event) in
                switch event {
                case .success(let model):
        
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    log.debug(error)
                }
                
            }
            .disposed(by: VC.rx.disposeBag)
    }
}
