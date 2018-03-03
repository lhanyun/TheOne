//
//  ResetViewModel.swift
//  TheOne
//
//  Created by lala on 2018/1/20.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import ObjectMapper

class ResetViewModel {
    
    //    var disposeBag = DisposeBag()
    
    //    let provider = MoyaProvider<APIManager>()
    
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    let validatedPhone: Observable<ValidationResult>
    
    // Is register button enabled
    let resetEnabled: Observable<Bool>
    
    let resetStutas: Observable<Bool>
    
    init(
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        phone: Observable<String>,
        resetBtn: Observable<Void>
        ) {
        
        validatedUsername = username
            .map {
                let numberOfCharacters = $0.count
                if numberOfCharacters == 0 {
                    return .empty
                }
                
                if numberOfCharacters < minimalAccountLength {
                    return .failed(message: "账号不少于\(minimalAccountLength)字符")
                }
                
                return .ok(message: "")
            }
            .share(replay: 1)
        
        validatedPassword = password
            .map {
                let numberOfCharacters = $0.count
                if numberOfCharacters == 0 {
                    return .empty
                }
                
                if numberOfCharacters < minimalPaswordLength {
                    return .failed(message: "密码不少于\(minimalPaswordLength)字符")
                }
                
                return .ok(message: "")
            }
            .share(replay: 1)
        
        validatedPasswordRepeated = Observable
            .combineLatest(password, repeatedPassword) {
                if $1.count == 0 {
                    return .empty
                }
                if $0 == $1 {
                    return .ok(message: "")
                }
                else {
                    return .failed(message: "两次密码输入不同")
                }
            }
            .share(replay: 1)
        
        validatedPhone = phone
            .map { phoneNum -> ValidationResult in
                if phoneNum.count == 0 {
                    return .empty
                } else if phoneNum.count < 11 {
                    return .failed(message: "电话号码不少于11个字符")
                } else if !Tools().isTelNumber(num: phoneNum) {
                    return .failed(message: "请输入正确的电话号码")
                }
                return .ok(message: "")
            }
            .share(replay: 1)
        
        resetEnabled = Observable
            .combineLatest(validatedUsername, validatedPassword, validatedPasswordRepeated, username, validatedPhone) { $0.isValid && $1.isValid && $2.isValid && ($3.count >= minimalAccountLength) && $4.isValid
            }
            .share(replay: 1)
        
        
        //重置密码
        let usernameAndPassword = Observable.combineLatest(username, password, phone) { (username: $0, password: $1, phone: $2) }
        resetStutas = resetBtn
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return provider.rx.request(.resetPassword(username: pair.username, password: pair.password, phone: pair.phone))
                    .mapObject(RegisterModel.self)
                    .map { model -> Bool in
                        
                        let m = model as RegisterModel
                        TipHUD.sharedInstance.showTips(m.codeMsg)
                        
                        return m.code == 200
                    }
                    .asDriver(onErrorJustReturn: false)
            }
            .catchErrorJustReturn(false)
            .share(replay: 1)
    }
    
}
