//
//  UpdateFileModel.swift
//  TheOne
//
//  Created by lala on 2018/2/1.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper

struct UpdateFileModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data: [String] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
    
}
