//
//  TOTimeNodeCell.swift
//  TheOne
//
//  Created by lala on 2017/11/21.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TOTimeNodeCell: TOTableViewCell {

    @IBOutlet weak var timeBtn: UIButton!

    @IBOutlet weak var personBtn: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    //是否可编辑  从项目详情页面不能编辑
    var isEdit: Bool = true {
        didSet {
            timeBtn.isEnabled = isEdit
            personBtn.isEnabled = isEdit
            textView.isEditable = isEdit
            cancelBtn.isEnabled = isEdit
            cancelBtn.isHidden = !isEdit
        }
    }
    
    var model:TimeNodeModel? {
        didSet {
            timeBtn.setTitle(model?.time, for: .normal)
            personBtn.setTitle(model?.affiliatedPerson, for: .normal)
            textView.text = model?.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        timeBtn.layer.cornerRadius = 4
        timeBtn.backgroundColor = UIColor.clear
        timeBtn.layer.borderColor = UIColor.flatWhite.cgColor
        timeBtn.layer.borderWidth = 1
        
        personBtn.layer.cornerRadius = 4
        personBtn.backgroundColor = UIColor.clear
        personBtn.layer.borderColor = UIColor.flatWhite.cgColor
        personBtn.layer.borderWidth = 1
        
        cancelBtn.layer.cornerRadius = 13
    }
    
}
