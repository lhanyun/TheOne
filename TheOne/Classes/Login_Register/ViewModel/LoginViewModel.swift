//
//  LoginViewModel.swift
//  TheOne
//
//  Created by lala on 2017/11/1.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper
import FileKit

class LoginViewModel {
    
    // 输出
    let usernameValid: Observable<ValidationResult>
    let passwordValid: Observable<ValidationResult>
    let loginValid: Observable<Bool>
    let loginStutas: Observable<ValidationResult>
    
    init( username: Observable<String>, password: Observable<String>, loginBtn: Observable<Void>) {
        
        usernameValid = username
            .map {
                if $0.count == 0 {
                    return .empty
                } else if $0.count < minimalAccountLength {
                    return .failed(message: "账号不少于\(minimalAccountLength)个字符")
                }
                return .ok(message: "")
            }
            .share(replay: 1)
        
        passwordValid = password
            .map {
                if $0.count == 0 {
                    return .empty
                } else if $0.count < minimalAccountLength {
                    return .failed(message: "密码不少于\(minimalPaswordLength)个字符")
                }
                return .ok(message: "")
            }
            .share(replay: 1)
        
        loginValid = Observable.combineLatest(usernameValid, passwordValid) { $0.isValid && $1.isValid }
            .share(replay: 1)
        
        //登入
        let usernameAndPassword = Observable
            .combineLatest(username, password) { (username: $0, password: $1) }
        
        loginStutas = loginBtn
        .withLatestFrom(usernameAndPassword)
        .flatMapLatest { pair in
            return provider.rx.request(.login(username: pair.username, password: pair.password))
                .mapObject(LoginModel.self)
                .map { model -> ValidationResult in
                    
                    let m = model as LoginModel
                    
                    if m.code == 200 { //保存用户信息
                        
                        Tools().userInfo = m.data!
                    }
                    
                    return (m.code == 200) ? (.ok(message: m.codeMsg)) : (.failed(message: m.codeMsg))
                    
                }
                .asDriver(onErrorJustReturn: .failed(message: "请检查网络"))
            }
            .catchErrorJustReturn(.failed(message: "请检查网络"))
            .share(replay: 1)
        
    }

}


