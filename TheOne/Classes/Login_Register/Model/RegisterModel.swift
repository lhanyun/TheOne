//
//  RegisterModel.swift
//  TheOne
//
//  Created by lala on 2017/11/8.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
    }

}
