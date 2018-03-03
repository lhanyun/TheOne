//
//  LoginModel.swift
//  TheOne
//
//  Created by lala on 2017/11/3.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper

struct LoginModel: Mappable {
    
    var code:Int = 0
    var codeMsg: String = ""
    var data: UserInfo?

    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]

    }
    
}

struct UserInfo: Mappable {
    
    var userNickName:String = ""
    var userIcon:String = ""
    var userPhone:String = ""
    var userName:String = ""
    var userSession:String = ""
    var userLogin:String = ""
    var userRole:String = ""
    var id:Int = 0
    var projectId:String = ""
    var ownProjectId:String = ""
    var projectModules:String = ""
    var userModule:String = ""
    var userEmail:String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        userNickName <- map["userNickName"]
        userIcon <- map["userIcon"]
        userPhone <- map["userPhone"]
        userName <- map["userName"]
        userSession <- map["userSession"]
        userLogin <- map["userLogin"]
        userRole <- map["userRole"]
        id <- map["id"]
        projectId <- map["projectId"]
        ownProjectId <- map["ownProjectId"]
        projectModules <- map["projectModules"]
        userModule <- map["userModule"]
        userEmail <- map["userEmail"]
    }
    
}


