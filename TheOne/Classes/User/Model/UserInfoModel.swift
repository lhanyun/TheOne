//
//  UserViewModel.swift
//  TheOne
//
//  Created by lala on 2018/2/22.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserInfoModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data:UserModel?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct UserModel: Mappable {
    
    var taskNum:String = ""
    var projectNum:String = ""
    var taskNorNum:String = ""
    var taskppNum:String = ""
    var taskppOverNum:String = ""
    var taskNorOverNum:String = ""
    var praiseNum:String = ""
    
    var taskOverNum: String = ""
    var taskBugNum: String = ""
    var taskBugOverNum: String = ""
    var module: String = ""
    
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        taskNum <- map["taskNum"]
        projectNum <- map["projectNum"]
        taskNorNum <- map["taskNorNum"]
        taskppNum <- map["taskppNum"]
        taskppOverNum <- map["taskppOverNum"]
        taskNorOverNum <- map["taskNorOverNum"]
        praiseNum <- map["praiseNum"]
        
        taskOverNum <- map["taskOverNum"]
        taskBugNum <- map["taskBugNum"]
        taskBugOverNum <- map["taskBugOverNum"]
        module <- map["module"]
    }
}


    

