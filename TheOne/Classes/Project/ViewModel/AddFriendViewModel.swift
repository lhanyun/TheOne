//
//  AddFriendViewModel.swift
//  TheOne
//
//  Created by lala on 2017/12/7.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import NSObject_Rx

class AddFriendViewModel: NSObject {
    
    // 存放着解析完成的模型数组
    let models = Variable<[UserInfo]>([])
    
}

extension AddFriendViewModel: TOViewModelType {
    
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
        
        init(sections: Driver<[MemberListSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: AddFriendViewModel.MemberListInput) -> AddFriendViewModel.MemberListOutput {
        
        input.searchText
            .subscribe(onNext: {[weak self] element in
                
                providerI.rx.request(.member(projectId: input.projectId, isShow: input.isShow))
                    .mapObject(MemberModel.self)
                    .subscribe { [weak self] (event) in
                        
                        switch event {
                        case .success(let model):
                            
                            self?.models.value = model.data
                            
                        case .error(_):
                            
                            //若数据源为空，重新赋值一次，以触发mj_footer.isAutomaticallyHidden
                            if self?.models.value.count == 0 {
                                self?.models.value =  []
                            }
                            
                        }
                        
                    }
                    .disposed(by: (self?.rx.disposeBag)!)

            })
            .disposed(by: rx.disposeBag)
        
        
        let sections = models.asObservable()
            .map { (models) -> [MemberListSection] in
                
                // 当models的值被改变时会调用
                return [MemberListSection(items: models)]
            }
            .asDriver(onErrorJustReturn: [])
        
        let output = MemberListOutput(sections: sections)
        
//        output.requestCommond
//            .subscribe(onNext: {[weak self] isReloadData in
//
//                providerI.rx.request(.member)
//                    .mapObject(MemberModel.self)
//                    .subscribe { [weak self] (event) in
//
//                        switch event {
//                        case .success(let model):
//
//                            self?.models.value = model.memberList
//
//                            self?.dataSource = model.memberList
//
//                            TipHUD.sharedInstance.showTips("加载成功")
//
//                        case .error(_):
//
//                            //若数据源为空，重新赋值一次，以触发mj_footer.isAutomaticallyHidden
//                            if self?.models.value.count == 0 {
//                                self?.models.value =  []
//                            }
//
//                        }
//
//                    }
//                    .disposed(by: (self?.rx.disposeBag)!)
//
//            })
//            .disposed(by: rx.disposeBag)
        
        return output
    }
}
