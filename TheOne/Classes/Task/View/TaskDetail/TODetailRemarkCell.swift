//
//  TODetailRemarkCell.swift
//  TheOne
//
//  Created by lala on 2017/12/12.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ZLPhotoBrowser

class TODetailRemarkCell: TOTableViewCell {

    @IBOutlet weak var describeTask: UILabel!
    
    @IBOutlet weak var photoView: UIScrollView!
    
    var vc: TOTaskDetailViewController?
    
    @IBOutlet weak var audioView: UIScrollView!
    
    fileprivate let recoder = RecordManager.sharedInstance
    
    var photos: [String]? {
        didSet {
            
            for view in photoView.subviews {
                view.removeFromSuperview()
            }
            
            for (index, url) in (photos ?? []).enumerated() {
                
                let imgView: UIImageView = UIImageView(frame: CGRect(x: (60 + 10) * index, y: 0, width: 60, height: 60))
                
                imgView.isUserInteractionEnabled = true
                imgView.tag = index + 1
                imgView.cz_setImage(urlString: url, placeholderImage: nil)
                let tap = UITapGestureRecognizer(target: self, action: #selector(showPhotos))
                imgView.addGestureRecognizer(tap)
                imgView.contentMode = .scaleAspectFit
                
                photoView.addSubview(imgView)
            }
            
            photoView.contentSize = CGSize(width: (60 + 10) * (photos ?? []).count, height: 60)
        }
    }
    
    var audios: [String]? {
        didSet {
            for view in audioView.subviews {
                view.removeFromSuperview()
            }
            for (index, _) in (audios ?? []).enumerated() {
                let btn = TOAddTaskBtn(type: .custom)
                btn.frame = CGRect(x: (40 + 10) * index, y: 0, width: 40, height: 40)
                btn.tag = index + 1
                btn.addTarget(self, action: #selector(playAudio(btn:)), for: .touchUpInside)
                audioView.addSubview(btn)
            }
            audioView.contentSize = CGSize(width: (40 + 10) * (audios ?? []).count, height: 40)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //播放音频
    @objc fileprivate func playAudio(btn: UIButton) {
        recoder.pausePlay()
        guard let audios = audios else { return }
        recoder.play(path: audios[btn.tag - 1])
    }

    @objc fileprivate func showPhotos(_ gestureRecognizer: UITapGestureRecognizer) {
    
        let v = gestureRecognizer.view
        
        var urls: [Any] = []
        for str in photos ?? [] {
            
            guard let url = URL(string: str) else {
                log.debug("图片路径转URL失败")
                return
            }
            
            urls.append(url)
        }
        
        guard let index = v?.tag else {
            log.debug("获取ImgView的tag失败")
            return
        }
        
        let actionSheet = ZLPhotoActionSheet()
        actionSheet.sender = vc
        
        actionSheet.previewPhotos(urls, index: index - 1, hideToolBar: false, complete: { (result) in
            
        })
    }
    
}
