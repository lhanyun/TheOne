//
//  ChooseMemberViewModel.swift
//  TheOne
//
//  Created by lala on 2017/11/30.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import NSObject_Rx


enum TONetStatus {
    case none
    case error
    case noMoreData
}

class ChooseMemberViewModel: NSObject {
    
    // 存放着解析完成的模型数组
    let models = Variable<[UserInfo]>([])
    
    var dataSource = [UserInfo]()

}

extension ChooseMemberViewModel: TOViewModelType {
    
    typealias Input = MemberListInput
    typealias Output = MemberListOutput
    
    struct MemberListInput {
        
        let searchText: Observable<String>
        
        let projectId: String
        
        let isShow: String
        
        init(text: Observable<String>, Id: String, show: String) {
            searchText = text
            projectId = Id
            isShow = show
        }
    }
    
    struct MemberListOutput {
        // tableView的sections数据
        let sections: Driver<[MemberListSection]>
        
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommond = PublishSubject<Bool>()
        
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = Variable<TONetStatus>(.none)
        
        init(sections: Driver<[MemberListSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: ChooseMemberViewModel.MemberListInput) -> ChooseMemberViewModel.MemberListOutput {

        let sections = models.asObservable()
            .map { (models) -> [MemberListSection] in
                
                // 当models的值被改变时会调用
                return [MemberListSection(items: models)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let output = MemberListOutput(sections: sections)
        
        output.requestCommond
            .subscribe(onNext: {[weak self] isReloadData in
                
                provider.rx.request(.member(projectId: input.projectId, isShow: input.isShow))
                    .mapObject(MemberModel.self)
                    .subscribe { [weak self] (event) in
                        
                        switch event {
                        case .success(let model):
                            
                            self?.models.value = model.data
                            
                            self?.dataSource = model.data
                            
                            output.refreshStatus.value = .none
                            
                            TipHUD.sharedInstance.showTips("加载成功")
                            
                        case .error(_):
                            
                            output.refreshStatus.value = .error
                            
                            //若数据源为空，重新赋值一次，以触发mj_footer.isAutomaticallyHidden
                            if self?.models.value.count == 0 {
                                self?.models.value =  []
                            }
                            
                        }
                        
                    }
                    .disposed(by: (self?.rx.disposeBag)!)
                
            })
            .disposed(by: rx.disposeBag)
        
        input.searchText
            .subscribe(onNext: {[weak self] element in
                
                if element.count == 0 {
                    self?.models.value = (self?.dataSource)!
                    return
                }
                
                var heros = [UserInfo]()
                for (index, memberModel) in (self?.dataSource.enumerated())! {
                    if memberModel.userName.contains(element) {
                        
                        heros.append((self?.dataSource[index])!)
                    }
                }
                
                self?.models.value = heros
                
                output.refreshStatus.value = (heros.count == 0) ? .noMoreData : .none
                
            })
            .disposed(by: rx.disposeBag)
        
        return output
    }
}
