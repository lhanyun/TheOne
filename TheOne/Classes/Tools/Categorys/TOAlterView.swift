//
//  TOAlterView.swift
//  TheOne
//
//  Created by lala on 2017/12/21.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

protocol TOAlterViewDelegate {
    
    //必选方法
    func alterViewDidInPut(_ content: String, _ indexPath: IndexPath)
}

class TOAlterView: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var text: String = " "
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var delegate: TOAlterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        
        viewWithTag(100)?.backgroundColor = UIColor.flatWhite
        (viewWithTag(100) as! UIButton).setTitleColor(UIColor.black, for: .normal)
    }

    @IBAction func buttonAct(_ sender: UIButton) {
        
        //收起键盘
        textView.resignFirstResponder()
        
        sender.tag == 100 ? () : {
            guard let delegate = delegate else { return }
            delegate.alterViewDidInPut(text, indexPath)
        }()
        
        removeFromSuperview()
    }
    
    class func newTOAlterView(targetVC: TOBaseViewController, title: String = "请输入任务内容", indexPath: IndexPath) {
        
        let nib = UINib(nibName: "TOAlterView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TOAlterView
        
        v.delegate = targetVC as? TOAlterViewDelegate
        v.title.text = title
        v.indexPath = indexPath
        
        targetVC.view.addSubview(v)
        
        //约束
        v.snp.makeConstraints { (make) in
            
            make.top.equalTo(targetVC.navigationBar.snp.bottom)
            make.right.left.equalTo(targetVC.view)
            make.bottom.equalTo(targetVC.view)
            
        }
        
        v.textView.becomeFirstResponder()
    }
}

extension TOAlterView: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        text = (textView.text.count == 0) ? " " : textView.text
        
    }
    
}
