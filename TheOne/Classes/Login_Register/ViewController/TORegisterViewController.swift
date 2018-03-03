//
//  TORegisterViewController.swift
//  TheOne
//
//  Created by lala on 2017/10/31.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import Hero
import FontAwesomeKit

class TORegisterViewController: TOBaseViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatedPassword: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var validatedPasswordRepeated: UILabel!
    @IBOutlet weak var validatedPassword: UILabel!
    @IBOutlet weak var validatedUsername: UILabel!
    
    @IBOutlet weak var validatedNickname: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var validatedPhone: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    fileprivate var viewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "注册"
        
        let btn = UIButton(type: .system)
        let leftIcon = FAKIonIcons.iosArrowBackIcon(withSize: 28)
        btn.setAttributedTitle(leftIcon?.attributedString(), for: .normal)
        
        btn.addTarget(self, action: #selector(dismissRegisterVC), for: .touchUpInside)
        
        navItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
    }

    @objc fileprivate func dismissRegisterVC() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    deinit {
        log.debug("注册销毁")
    }
    
    override func initUI() {
        super.initUI()

        inputSetting()
        
        settingUIAnim()
        
    }
    
}

extension TORegisterViewController {
    
    fileprivate func settingUIAnim() {
        
//        isHeroEnabled = true
        
//        view.viewWithTag(100)?.heroID = "inputView"
//        registerBtn.heroID = "tapBtn"
        
//        registerBtn.heroModifiers = [.fade, .scale(0.5)]
    }
    
    fileprivate func inputSetting() {
        
        viewModel = RegisterViewModel(username: username.rx.text.orEmpty.asObservable(),
                                      password: password.rx.text.orEmpty.asObservable(),
                                      repeatedPassword: repeatedPassword.rx.text.orEmpty.asObservable(),
                                      nickname: nickname.rx.text.orEmpty.asObservable(),
                                      phone:phone.rx.text.orEmpty.asObservable(),
                                      registerBtn: registerBtn.rx.tap.asObservable())

        viewModel.validatedPassword
            .bind(to: validatedPassword.rx.validationResult)
            .disposed(by: rx.disposeBag)

        viewModel.validatedPasswordRepeated
            .bind(to: validatedPasswordRepeated.rx.validationResult)
            .disposed(by: rx.disposeBag)

        viewModel.registerEnabled
            .subscribe(onNext: {[weak self] element in
                self?.registerBtn.isEnabled = element
                self?.registerBtn.alpha = element ? 1.0 : 0.5
            })
            .disposed(by: rx.disposeBag)

        viewModel.validatedUsername
            .bind(to: validatedUsername.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedUsername
            .subscribe(onNext: {[weak self] element in
                
                switch element {
                case .failed, .ok:
                    self?.indicatorView.stopAnimating()
                default: break
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedPhone
            .bind(to: validatedPhone.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedNickname
            .bind(to: validatedNickname.rx.validationResult)
            .disposed(by: rx.disposeBag)

        viewModel.usernameV
            .bind(to: validatedUsername.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.usernameV
            .subscribe(onNext: {[weak self] element in
                switch element {
                case .empty:
                    self?.indicatorView.startAnimating()
                case .failed:
                    self?.indicatorView.stopAnimating()
                default: break
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.usernameE
            .bind(to: validatedUsername.rx.validationResult)
            .disposed(by: rx.disposeBag)

        viewModel.registerStutas
            .subscribe(onNext: {[weak self] element in
                if element {
                    TipHUD.sharedInstance.showTips("注册成功")
                    self?.register()
                }
            })
            .disposed(by: rx.disposeBag)
    }

    func register() {
        
        //注册环信
        EMClient.shared().register(withUsername: username.text, password: password.text) { (userName, error) in
            if error != nil {
                log.debug("注册环信成功")
            }
        }

        dismiss(animated: true, completion: nil)

    }
    
}
