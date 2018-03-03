//
//  TONoticeCell.swift
//  TheOne
//
//  Created by lala on 2017/11/21.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import RxSwift

class TONoticeCell: TOTableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    var notice: Observable<String>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notice = textView.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .share(replay: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
