//
//  ProjectDetailModel.swift
//  TheOne
//
//  Created by lala on 2017/11/21.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProjectDetailModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data:ProjectInfoModel?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct ProjectInfoModel: Mappable {
    
    var projectName:String = ""
    var projectNotice:String = ""
    var projectId:String = ""
    var creater:String = ""
    var postpone:String = ""
    var projectStatus:String = ""
    var createTime:String = ""
    var endTime:String = ""
    var timeNode:[TimeNodeModel] = []
    var members:[UserInfo] = []
    var taskNum:Int = 0
    var taskOverNum:Int = 0
    var taskBugNum:Int = 0
    var taskBugOverNum:Int = 0
    var taskNorNum:Int = 0
    var taskppNum:Int = 0
    var taskppOverNum:Int = 0
    var taskNorOverNum:Int = 0
    var userId:Int = 0
    var modules:[String] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        projectName <- map["projectName"]
        creater <- map["creater"]
        postpone <- map["postpone"]
        projectStatus <- map["projectStatus"]
        createTime <- map["createTime"]
        projectId <- map["projectId"]
        endTime <- map["endTime"]
        timeNode <- map["timeNode"]
        members <- map["members"]
        taskNum <- map["taskNum"]
        taskOverNum <- map["taskOverNum"]
        taskBugNum <- map["taskBugNum"]
        taskBugOverNum <- map["taskBugOverNum"]
        taskNorNum <- map["taskNorNum"]
        taskppNum <- map["taskppNum"]
        taskppOverNum <- map["taskppOverNum"]
        projectNotice <- map["projectNotice"]
        userId <- map["userId"]
        modules <- map["modules"]
    }
}

struct TimeNodeModel: Mappable {
    
    var time: String = ""
    var affiliatedPerson: String = ""
    var content:String = ""
    var createTime: String = ""
    
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        time <- map["time"]
        affiliatedPerson <- map["affiliatedPerson"]
        content <- map["content"]
        createTime <- map["createTime"]
    }
}

struct MemberList: Mappable {
    
    var imgUrl:String = ""
    var memberName:String = ""
    var moduleName:String = ""
    var memberID:String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        imgUrl <- map["imgUrl"]
        memberName <- map["memberName"]
        moduleName <- map["moduleName"]
        memberID <- map["memberID"]
    }

}

//struct NumModel: Mappable {
//    
//    var total:String = ""
//    var completeNum:String = ""
//    
//    init?(map: Map) { }
//    
//    mutating func mapping(map: Map) {
//        total <- map["total"]
//        completeNum <- map["completeNum"]
//    }
//    
//}
//
//struct TaskChartModel: Mappable {
//    
//    var normalComplete:String = ""
//    var normalDoing:String = ""
//    var postponeComplete:String = ""
//    var postponeNum:String = ""
//    
//    init?(map: Map) { }
//    
//    mutating func mapping(map: Map) {
//        normalComplete <- map["normalComplete"]
//        normalDoing <- map["normalDoing"]
//        postponeComplete <- map["postponeComplete"]
//        postponeNum <- map["postponeNum"]
//    }
//    
//}

