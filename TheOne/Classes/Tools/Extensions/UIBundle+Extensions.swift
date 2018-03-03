//
//  UIBundle+Extensions.swift
//  Swift_Equipment
//
//  Created by lala on 2017/3/19.
//  Copyright © 2017年 lala. All rights reserved.
//

import Foundation

extension Bundle {
    
    //获取命名空间 -- 项目名称
    var nameSpace:String {
        return infoDictionary!["CFBundleName"] as? String ?? ""
    }
    
}
