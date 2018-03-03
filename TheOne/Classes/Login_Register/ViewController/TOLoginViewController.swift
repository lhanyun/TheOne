//
//  TOLoginViewController.swift
//  TheOne
//
//  Created by lala on 2017/10/29.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import LTMorphingLabel
import Hero
import pop
import ChameleonFramework

class TOLoginViewController: TOBaseViewController  {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var usernameValid: UILabel!
    @IBOutlet weak var passwordValid: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    fileprivate var viewModel: LoginViewModel!

    fileprivate var i = 0

    @IBOutlet weak var titleLogin: LTMorphingLabel!
    
    fileprivate var textArray = [
        "Agile Development",
        "Starts With TheOne",
        "敏捷开发从TheOne开始"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登入"
    }
    
    override func initUI() {
        super.initUI()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        
        inputSetting()
        
        settingUIAnim()

    }
    
    deinit {
        log.debug("登入销毁")
    }
   
}

extension TOLoginViewController {
    
    fileprivate func settingUIAnim() {
        
        
        
        RCAnimatedPath.shared.drawAnimatedText(in: titleLogin,
                                               with: "Agile Development",
                                               duration: 3,
                                               lineWidth: 2,
                                               textColor: FlatBlack(),
                                               fontName: "PingFangSC-Bold",
                                               fontSize: 30)
        
//        titleLogin.text = "敏捷开发从TheOne开始"
//
//        titleLogin.delegate = self
//        if let effect = LTMorphingEffect(rawValue: 6) {
//            titleLogin.morphingEffect = effect
//        }
    
    }
    
    //设置账号和密码的输入逻辑
    fileprivate func inputSetting() {

        //提示符
        usernameValid.text = "账号不少于\(minimalAccountLength)个字符"
        passwordValid.text = "密码不少于\(minimalPaswordLength)个字符"
        
        viewModel = LoginViewModel(
            username: username.rx.text.orEmpty.asObservable(),
            password: password.rx.text.orEmpty.asObservable(),
            loginBtn: loginBtn.rx.tap.asObservable()
        )

        viewModel.usernameValid
            .bind(to: usernameValid.rx.validationResult)
            .disposed(by: rx.disposeBag)

        viewModel.passwordValid
            .bind(to: passwordValid.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.loginValid
            .subscribe(onNext: {[weak self] element in
                
                self?.loginBtn.isEnabled = element
                self?.loginBtn.alpha = element ? 1.0 : 0.5
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loginStutas
            .subscribe(onNext: {[weak self] element in

                if element.isValid {
                    TipHUD.sharedInstance.showTips(element.description)
                    self?.login()
                } else {
                    
                    self?.shakeButton()
                    self?.showLabel(element.description)
                }

            })
            .disposed(by: rx.disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: {[weak self] element in
                
                self?.hideLabel()
            })
            .disposed(by: rx.disposeBag)
    }

}

//MARK: 点击动作 及 动画
extension TOLoginViewController {
    
    //登入
    fileprivate func login() {
        
        //登入环信
        if !(EMClient.shared().options.isAutoLogin) {//是否自动登入
            EMClient.shared().login(withUsername: username.text, password: password.text, completion: { (userName, error) in
                if error == nil {
                    //设置自动登入
                    EMClient.shared().options.isAutoLogin = true
                    EMClient.shared().options.isAutoAcceptGroupInvitation = true
                    log.debug("登入环信成功")
                }
            })
        }
        
        let projectSB = UIStoryboard(name: "Project", bundle:nil)
        let vc = projectSB.instantiateInitialViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    //注册
    @objc fileprivate func register() {

        performSegue(withIdentifier: "register", sender: nil)
        
    }
    
    fileprivate func shakeButton() {
        
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        positionAnimation?.velocity = NSNumber(value: 2000)
        positionAnimation?.springBounciness = 20
        
        loginBtn.layer.pop_add(positionAnimation, forKey: "positionAnimation")
    }
    
    fileprivate func showLabel(_ str: String) {
        errorLabel.text = str
        errorLabel.layer.opacity = 1.0
        let layerScaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        layerScaleAnimation?.springBounciness = 18;
        layerScaleAnimation?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        errorLabel.layer.pop_add(layerScaleAnimation, forKey: "labelScaleAnimation")
        
        let layerPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        
        let dis:Float = (Float)(loginBtn.layer.position.y + loginBtn.intrinsicContentSize.height)
        
        layerPositionAnimation?.toValue = NSNumber(value: dis)
        
        layerPositionAnimation?.springBounciness = 12
        
        errorLabel.layer.pop_add(layerPositionAnimation, forKey: "layerPositionAnimation")
        
    }
    
    fileprivate func hideLabel() {

        let layerScaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        layerScaleAnimation?.toValue = NSValue(cgSize: CGSize(width: 0.5, height: 0.5))
        errorLabel.layer.pop_add(layerScaleAnimation, forKey: "labelScaleAnimation")
        
        let layerPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        layerPositionAnimation?.toValue = NSNumber(value: (Float)(loginBtn.layer.position.y))
        errorLabel.layer.pop_add(layerPositionAnimation, forKey: "layerPositionAnimation")
        
    }
    
}

//MARK:LTMorphingLabelDelegate
extension TOLoginViewController: LTMorphingLabelDelegate {
    
    //广告语动画 - “敏捷开发从TheOne开始”
//    func morphingDidComplete(_ label: LTMorphingLabel) {
//
//        if i == 2 {
//            return
//        }
//
//        i = i >= textArray.count - 1 ? 0 : i + 1
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//
//            self.titleLogin.text = self.textArray[self.i]
//        }
//
//    }
    
    
    
}
