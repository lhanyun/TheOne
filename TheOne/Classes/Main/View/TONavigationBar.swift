//
//  TONavigationBar.swift
//  TheOne
//
//  Created by lala on 2017/10/31.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TONavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TONavigationBar: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    
}
