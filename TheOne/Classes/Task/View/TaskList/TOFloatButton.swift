//
//  TOFloatButton.swift
//  TheOne
//
//  Created by lala on 2018/1/30.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit

protocol TOFloatButtonDelegate {
    
    func btnTouchUpInside(_ sender: UIButton)
}

enum LocationTag: Int {
    case kLocationTag_top = 1
    case kLocationTag_left = 2
    case kLocationTag_bottom = 3
    case kLocationTag_right = 4
}

class TOFloatButton: UIButton {
    
    var _w = IPHONE_WIDTH
    var _h = IPHONE_HEIGHT - CGFloat(TabBarHeight)
    
    var _locationTag: LocationTag?
    
    var delegate: TOFloatButtonDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgSize = CGSize(width: 80, height: 80)
        let icon = FAKIonIcons.iosPlusOutlineIcon(withSize: 80)
        icon?.drawingBackgroundColor = UIColor.flatWhite
        icon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.flatBlue)
        
        guard let img = icon?.image(with: imgSize) else { return }
    
        setImage(img, for: .normal)
        
        layer.cornerRadius = frame.width/2
        layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addTask))
        addGestureRecognizer(tap)
    }
    
    @objc fileprivate func addTask() {
        
        guard let delegate = delegate else { return }
        
        delegate.btnTouchUpInside(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug("touchesCancelled")
    }
    
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        computeOfLocation {
            
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first
        
        guard let movedPT = touch?.location(in: superview) else {
            return
        }
       
        if ( movedPT.x - frame.width/2 < 0.0 || movedPT.x + frame.width/2 > _w || movedPT.y - frame.height/2 < 0.0 || movedPT.y + frame.height/2 > _h ) {
            return;
        }
        
        center = movedPT
    }
    
    func computeOfLocation(_ complete:@escaping ()->()) {

        let x = center.x
        let y = center.y
        var m = CGPoint(x: 0.0, y: 0.0)
        m.x = x
        m.y = y
        
        //取两边靠近--------------------------
        if (x < _w/2) {
            _locationTag = .kLocationTag_left
        } else {
            _locationTag = .kLocationTag_right
        }
        
        switch _locationTag {
        case .kLocationTag_top?:
            m.y = 0 + 30.0
        case .kLocationTag_left?:
            m.x = 0 + 30.0
        case .kLocationTag_bottom?:
            m.y = _h - 30.0
        case .kLocationTag_right?:
            m.x = _w - 30.0
        case .none:
            break
        }
    
        //这个是在旋转是微调浮标出界时
        if (m.x > _w - 30.0) {
            m.x = _w - 30.0
        }
    
        if (m.y > _h - 30.0) {
            m.y = _h - 30.0
        }
    
        UIView.animate(withDuration: 0.1, animations: {
            self.center = m
        }) { (finished) in
            complete()
        }
    }

}
