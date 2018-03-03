//
//  TOThemeViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/10.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOThemeViewController: TOBaseViewController {
    
    //获取主题字典
    var themeDic: [String : String] = {
        
        guard let themeDic = UserDefaults.standard.dictionary(forKey: CHOOSETHEME) else {
            return ["navColor" : UIColor.flatPlum.hexValue(),
                    "btnColor" : UIColor.flatBlue.hexValue(),
                    "viewColor" : UIColor.flatWhite.hexValue()]
        }
        return themeDic as! [String : String]
    }()
    
    var navColor: String?
    var btnColor: String?
    var viewColor: String?
    
    var navColorVs: [UIView] = []
    var btnColorVs: [UIView] = []
    var viewColorVs: [UIView] = []
    
    var navColors: [String] = [UIColor.flatPowderBlue.hexValue(),
                               UIColor.flatSkyBlue.hexValue(),
                               UIColor.flatBlue.hexValue(),
                               UIColor.flatWhite.hexValue(),
                               UIColor.flatPlum.hexValue()]
    
    var btnColors: [String] = [UIColor.flatPowderBlue.hexValue(),
                               UIColor.flatSkyBlue.hexValue(),
                               UIColor.flatOrange.hexValue(),
                               UIColor.flatPurple.hexValue(),
                               UIColor.flatBlue.hexValue()]
    
    var viewColors: [String] = [UIColor.flatLime.hexValue(),
                                UIColor.flatYellow.hexValue(),
                                UIColor.flatNavyBlue.hexValue(),
                                UIColor.flatBlue.hexValue(),
                                UIColor.flatWhite.hexValue()]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "切换主题"

        navItem.rightBarButtonItem = UIBarButtonItem(title: "完成", selector: #selector(chooseOver), target: self, isBack: false)
        navItem.rightBarButtonItem?.isEnabled = false //默认为 不可点击
        
        setColorViewAct()
        
        //初始化颜色数据
        initData()
    }
    
    fileprivate func initData() {
        
        navColor = themeDic["navColor"]
        btnColor = themeDic["btnColor"]
        viewColor = themeDic["viewColor"]
    }
    
    fileprivate func setColorViewAct() {
        
        for colorView in view.subviews {
            
            if colorView.tag >= 10 && colorView.tag < 40 {
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAct))
                colorView.addGestureRecognizer(tap)
                
                colorView.layer.cornerRadius = 8
                colorView.layer.borderWidth = 2
                colorView.layer.borderColor = UIColor.clear.cgColor
                
                if colorView.tag >= 10 && colorView.tag < 20 {
                    navColorVs.append(colorView)
                } else if colorView.tag >= 20 && colorView.tag < 30 {
                    btnColorVs.append(colorView)
                } else if colorView.tag >= 30 && colorView.tag < 40 {
                    viewColorVs.append(colorView)
                }
            }

        }
        
    }
    
    //将所选择的颜色赋值
    @objc fileprivate func tapAct(_ sender: UITapGestureRecognizer) {
        
        navItem.rightBarButtonItem?.isEnabled = true
        
        guard let colorView = sender.view else { return }

        if colorView.tag >= 10 && colorView.tag < 20 {
            
            navColor = navColors[colorView.tag - 10]
            for view in navColorVs {
                view.layer.borderColor = UIColor.clear.cgColor
            }
            
        } else if colorView.tag >= 20 && colorView.tag < 30 {
            
            btnColor = btnColors[colorView.tag - 20]
            for view in btnColorVs {
                view.layer.borderColor = UIColor.clear.cgColor
            }
            
        } else if colorView.tag >= 30 && colorView.tag < 40 {
            
            viewColor = viewColors[colorView.tag - 30]
            for view in viewColorVs {
                view.layer.borderColor = UIColor.clear.cgColor
            }
            
        }
        
        colorView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc fileprivate func chooseOver() {
        
        themeDic["navColor"] = navColor
        themeDic["btnColor"] = btnColor
        themeDic["viewColor"] = viewColor
        
        //存储颜色值
        UserDefaults.standard.set(themeDic, forKey: CHOOSETHEME)
        
        //发送更换主题通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
        
        navigationController?.popViewController(animated: true)
        
    }
}


