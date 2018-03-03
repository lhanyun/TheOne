//
//  TOAddTaskCell.swift
//  TheOne
//
//  Created by lala on 2017/12/13.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework
import RxSwift

typealias addTaskCellBlock = (Int, String) -> Void
class TOAddTaskCell: TOTableViewCell {
    
    var postValueBlock:addTaskCellBlock?

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var photoBtn: UIButton!
    
    @IBOutlet weak var auidoBtn: UIButton!
    
    @IBOutlet weak var auidoScroll: UIScrollView!
    
    @IBOutlet weak var photoScroll: UIScrollView!
    
    var notice: Observable<String>?
    
    let recoder = RecordManager.sharedInstance
    
    var auidos: [String] = [] {
        didSet {
            for view in auidoScroll.subviews {
                view.removeFromSuperview()
            }
            for (index, _) in auidos.enumerated() {
                let btn = TOAddTaskBtn(type: .custom)
                btn.frame = CGRect(x: (27 + 10) * index, y: 0, width: 27, height: 27)
                btn.tag = index + 1
                btn.addTarget(self, action: #selector(playAudio(btn:)), for: .touchUpInside)
                btn.btn?.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
                auidoScroll.addSubview(btn)
            }
            auidoScroll.contentSize = CGSize(width: (27 + 10) * auidos.count, height: 27)
        }
    }
    
    var photos: [UIImage] = [] {
        didSet {
            for view in photoScroll.subviews {
                view.removeFromSuperview()
            }
            for (index, img) in photos.enumerated() {
                
                let btn = TOAddTaskBtn(type: .custom)
                btn.frame = CGRect(x: (60 + 10) * index, y: 0, width: 60, height: 60)
                btn.tag = index + 10
                btn.addTarget(self, action: #selector(showPhoto(btn:)), for: .touchUpInside)
                btn.btn?.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
                btn.backgroundColor = UIColor.flatBlack
                btn.setImage(img, for: .normal)
                btn.imageView?.contentMode = .scaleAspectFit
                photoScroll.addSubview(btn)
            }
            
            photoScroll.contentSize = CGSize(width: (60 + 10) * photos.count, height: 60)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        auidoScroll.contentSize = CGSize(width: 60 * 4, height: 27)
        auidoScroll.layer.masksToBounds = false
        photoScroll.contentSize = CGSize(width: 60 * 4, height: 60)
        photoScroll.layer.masksToBounds = false
        
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = FlatBlack().cgColor
        textView.layer.borderWidth = 1
        textView.backgroundColor = BASE_COLOR
        
        notice = textView.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .share(replay: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //播放音频
    @objc fileprivate func playAudio(btn: UIButton) {
        recoder.pausePlay()
        recoder.play(path: auidos[btn.tag - 1])
    }
    
    //查看图片、视频
    @objc fileprivate func showPhoto(btn: UIButton) {
        
        guard let postValueBlock = self.postValueBlock else { return }
        postValueBlock((btn.tag - 10), "show")
    }
    
    //删除按钮回调
    @objc fileprivate func deleteBtn(btn: UIButton) {
        
        guard let postValueBlock = self.postValueBlock else { return }
        postValueBlock((btn.superview?.tag)!, "delete")
    }
}
