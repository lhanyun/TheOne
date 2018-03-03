//
//  TOResetPasswordViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/20.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

class TOResetPasswordViewController: TOBaseViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatedPassword: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var validatedPasswordRepeated: UILabel!
    @IBOutlet weak var validatedPassword: UILabel!
    @IBOutlet weak var validatedUsername: UILabel!
    
    
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBOutlet weak var validatedPhone: UILabel!

    fileprivate var viewModel: ResetViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "重置密码"
        
        let btn = UIButton(type: .system)
        let leftIcon = FAKIonIcons.iosArrowBackIcon(withSize: 28)
        btn.setAttributedTitle(leftIcon?.attributedString(), for: .normal)
        
        btn.addTarget(self, action: #selector(dismissResetVC), for: .touchUpInside)
        
        navItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc fileprivate func dismissResetVC() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    deinit {
        log.debug("重置密码销毁")
    }
    
    override func initUI() {
        super.initUI()
        
        inputSetting()
    }
    
}

extension TOResetPasswordViewController {
    
    fileprivate func inputSetting() {
        
        viewModel = ResetViewModel(username: username.rx.text.orEmpty.asObservable(),
                                      password: password.rx.text.orEmpty.asObservable(),
                                      repeatedPassword: repeatedPassword.rx.text.orEmpty.asObservable(),
                                      phone:phone.rx.text.orEmpty.asObservable(),
                                      resetBtn: resetBtn.rx.tap.asObservable())
        
        viewModel.validatedPassword
            .bind(to: validatedPassword.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedPasswordRepeated
            .bind(to: validatedPasswordRepeated.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.resetEnabled
            .subscribe(onNext: {[weak self] element in
                self?.resetBtn.isEnabled = element
                self?.resetBtn.alpha = element ? 1.0 : 0.5
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedUsername
            .bind(to: validatedUsername.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedPhone
            .bind(to: validatedPhone.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.resetStutas
            .subscribe(onNext: {[weak self] element in
                if element {
                    self?.dismissResetVC()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
}
