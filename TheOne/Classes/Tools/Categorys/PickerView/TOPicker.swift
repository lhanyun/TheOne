//
//  TOPicker.swift
//  TheOne
//
//  Created by lala on 2017/12/13.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import SnapKit

protocol TOPickerViewDelegate {
    
    //必选方法
    func pickerViewDidSelect(_ index: Int, _ content: String, _ indexPath: IndexPath)
}

class TOPicker: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: TOPickerViewDelegate?
    
    var dataSource: [String] = []
    
    var row: Int = 0
    
    //用户是否选择了pickerView
//    var isSelect:Bool = false
    
    var indexPath: IndexPath = IndexPath(row: 1000, section: 1000)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func buttonAct(_ sender: UIButton) {
        
        hiddenView()
        
        sender.tag == 100 ? () : {
            guard let delegate = delegate else { return }
            delegate.pickerViewDidSelect(row, dataSource[row], indexPath)
        }()
        
//        guard let delegate = delegate else { return }
//
//        if sender.tag == 100 {
//
//            delegate.pickerViewDidSelect(0, "", indexPath)
//
//        } else {
//
//            if !isSelect {
//
//                delegate.pickerViewDidSelect(0, dataSource[0], indexPath)
//
//            }
//
//        }
    }
    
    class func newTOPickerView(targetVC: TOBaseViewController, dataSource: [String], title: String, indexPath: IndexPath) {
        
        let nib = UINib(nibName: "TOPicker", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TOPicker
        
        v.delegate = targetVC as? TOPickerViewDelegate
        v.dataSource = dataSource
        v.title.text = title
        v.indexPath = indexPath
//        v.isSelect = false
        
        //获取数据后，刷新pickerView
        v.pickerView.reloadAllComponents()

        targetVC.view.addSubview(v)
        
        //约束
        v.snp.makeConstraints { (make) in
            
            make.top.equalTo(targetVC.navigationBar.snp.bottom)
            make.right.left.equalTo(targetVC.view)
            make.bottom.equalTo(targetVC.view)
            
        }

        v.setSubView(v: v)

    }
    
    fileprivate func setSubView(v: TOPicker) {
        
        v.bgView.transform = CGAffineTransform(translationX: 0, y: 250)
        UIView.animate(withDuration: 0.3, animations: {
            v.bgView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    
        v.viewWithTag(100)?.backgroundColor = UIColor.clear
        v.viewWithTag(200)?.backgroundColor = UIColor.clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hiddenView()
    }
    
    fileprivate func hiddenView() {
        
        bgView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.transform = CGAffineTransform(translationX: 0, y: 250)
        }, completion: { (_) in
            self.removeFromSuperview()
        })
        
    }
}

extension TOPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.row = row
        
//        guard let delegate = delegate else { return }
//
//        delegate.pickerViewDidSelect(row, dataSource[row], indexPath)

//        isSelect = true
    }
}
