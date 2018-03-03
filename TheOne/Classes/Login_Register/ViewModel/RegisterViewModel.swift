//
//  RegisterViewModel.swift
//  TheOne
//
//  Created by lala on 2017/11/1.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import ObjectMapper

class RegisterViewModel {
    
//    var disposeBag = DisposeBag()

//    let provider = MoyaProvider<APIManager>()

    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    let validatedNickname: Observable<ValidationResult>
    let validatedPhone: Observable<ValidationResult>
    
    //usernameV、username两个变量是用来实现“正在输入...”和“账号不少于\(minimalAccountLength)字符”的相关逻辑
    let usernameV: Observable<ValidationResult>
    let usernameE: Observable<ValidationResult>

    // Is register button enabled
    let registerEnabled: Observable<Bool>
    
    let registerStutas: Observable<Bool>

    init(
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        nickname: Observable<String>,
        phone: Observable<String>,
        registerBtn: Observable<Void>
        ) {

        validatedUsername = username
            .distinctUntilChanged()
            .debounce(0.51, scheduler: MainScheduler.instance)
            .filter { return ($0.count >= minimalAccountLength && Tools().judgeTheillegalCharacter(character: $0))}
            .flatMapLatest { username in
                return providerI.rx.request(.validateUsername(username: username))
                        .mapObject(RegisterModel.self)
                        .map { model -> ValidationResult in

                            let m = model as RegisterModel
                            return (m.code == 200) ? (.ok(message: "账号可用")) : (.failed(message: m.codeMsg))
                            
                         }
                         .asDriver(onErrorJustReturn: .failed(message: "连接不到服务，请检查网络"))
             }
            .catchErrorJustReturn(.failed(message: "连接不到服务，请检查网络"))
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
                
                return .ok(message: "密码可用")
            }
            .share(replay: 1)
        
        validatedPasswordRepeated = Observable
            .combineLatest(password, repeatedPassword) {
                if $1.count == 0 {
                    return .empty
                }
                if $0 == $1 {
                    return .ok(message: "输入正确")
                }
                else {
                    return .failed(message: "两次密码输入不同")
                }
            }
            .share(replay: 1)
        
        validatedNickname = nickname
            .map { nickname -> ValidationResult in
                if nickname.count == 0 {
                    return .empty
                } else if nickname.count > 11 {
                    return .failed(message: "昵称必须是1~10位")
                }
                return .ok(message: "")
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
        
        registerEnabled = Observable
            .combineLatest(validatedUsername, validatedPassword, validatedPasswordRepeated, username, validatedPhone, validatedNickname) { $0.isValid && $1.isValid && $2.isValid && ($3.count >= minimalAccountLength) && $4.isValid && $5.isValid
            }
            .share(replay: 1)
        
        usernameV = username
            .distinctUntilChanged()
            .filter { return $0.count > 0}
            .debounce(0.3, scheduler: MainScheduler.instance)
            .map{ username  -> ValidationResult in
                if username.count == 0 {
                    return .empty
                } else if !Tools().judgeTheillegalCharacter(character: username) {
                    return .failed(message: "只能输入字母或数字")
                } else if username.count < minimalAccountLength {
                    return .failed(message: "账号不少于\(minimalAccountLength)字符")
                }
                return .empty
            }
        .share(replay: 1)
        
        usernameE = username
            .distinctUntilChanged()
            .map{ username  -> ValidationResult in
                if username.count == 0 {
                    return .empty
                }
                return .validating
            }
            .share(replay: 1)
        
        
        //注册
        let usernameAndPassword = Observable.combineLatest(username, password, nickname, phone) { (username: $0, password: $1, nickname: $2, phone: $3) }
        registerStutas = registerBtn
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return provider.rx.request(.register(username: pair.username, password: pair.password, nickname: pair.nickname, phone: pair.phone))
                    .mapObject(RegisterModel.self)
                    .map { model -> Bool in

                        let m = model as RegisterModel
                        return m.code == 200
                    }
                    .asDriver(onErrorJustReturn: false)
            }
            .catchErrorJustReturn(false)
            .share(replay: 1)
    }
    
}




