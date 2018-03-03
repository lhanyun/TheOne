//
//  TOFitlerView.swift
//  TheOne
//
//  Created by lala on 2017/12/9.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework
import pop

typealias fitlerViewBlock = (_ sort: Int, _ label: Int, _ selectMe: Int, _ isbool: Bool) -> Void

class TOFitlerView: UIView {
    
    @IBOutlet weak var fitlerView: UIView!
    
    @IBOutlet weak var forMe: UIButton!
    
    var postValueBlock:fitlerViewBlock?

    fileprivate var firstBtns:Array = [UIButton]()
    
    fileprivate var secondBtns:Array = [UIButton]()
    
    var sortIndex: Int = 10
    
    var labelIndex: Int = 20
    
    var forMeIndex: Int = 0 {
        didSet {
            if forMeIndex == 1 {
                forMe.isSelected = true
                allTask.isSelected = false
            } else {
                forMe.isSelected = false
                allTask.isSelected = true
            }
        }
    }
    
    @IBOutlet weak var allTask: UIButton!
    
    @IBAction func forMeAction(_ sender: UIButton) {
        
        if sender.tag == 30 {
            forMe.isSelected = true
            allTask.isSelected = false
            forMeIndex = 1
        } else {
            forMe.isSelected = false
            allTask.isSelected = true
            forMeIndex = 0
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        
        forMe.backgroundColor = UIColor.clear
        
        allTask.backgroundColor = UIColor.clear
    }
    
    class func newTOFitlerView(sortIndex: Int, labelIndex: Int, forMeIndex: Int) -> TOFitlerView {
        
        let nib = UINib(nibName: "TOFitlerView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TOFitlerView
        
        v.sortIndex = sortIndex + 10
        v.labelIndex = labelIndex + 20
        v.forMeIndex = forMeIndex
        
        v.setFitlerViewButton()
        
        return v
    }
    
}

extension TOFitlerView {
    
    //设置视图按钮属性
    fileprivate func setFitlerViewButton() {
        
        for view in fitlerView.subviews {
            
            if view.isKind(of: UIButton.self) {
                
                let button = view as! UIButton
                
                if button.tag == 30 || button.tag == 31 { //跳过当前
                    continue
                }
                
                if button.tag != 100 && button.tag != 200 {
                    
                    button.layer.cornerRadius = 6
                    
                    if button.tag != sortIndex && button.tag != labelIndex {
                        button.backgroundColor = FlatWhite()
                    }
                    
                    button.setTitleColor(FlatBlack(), for: .normal)
                    button.setTitleColor(FlatWhite(), for: .selected)

                    view.tag < 20 ? firstBtns.append(button) : secondBtns.append(button)
                    
                } else if view.tag == 100 {
                    view.backgroundColor = FlatWhite()
                } else if view.tag == 200 {
                    (view as! UIButton).setTitleColor(FlatWhite(), for: .normal)
                }
                
                    button.addTarget(self, action: #selector(buttonAct(button:)), for: .touchUpInside)
            }
        }
    }
    
    //按钮选择状态属性设置
    @objc fileprivate func buttonAct(button: UIButton) {
        
        if button.tag == 100 || button.tag == 200 {
            
            guard let postValueBlock = postValueBlock else {return}
            postValueBlock(sortIndex, labelIndex, forMeIndex, button.tag != 100)
            
            return
        }
        
        var btns: [UIButton] = []
        if button.tag < 20 {
            sortIndex = button.tag
            btns = firstBtns
        } else {
            labelIndex = button.tag
            btns = secondBtns
        }
        
        for btn in btns {

            btn.backgroundColor = FlatWhite()
            btn.isSelected = false

        }
        
        button.isSelected = true
        button.backgroundColor = FlatBlue()
    }
    
}
