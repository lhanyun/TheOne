//
//  UserSettingModel.swift
//  TheOne
//
//  Created by lala on 2018/2/22.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserSettingModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data:InfoModel?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct InfoModel: Mappable {
    
    var role: String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        
        role <- map["role"]
    }
}
