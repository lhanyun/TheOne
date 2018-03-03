//
//  TaskDetailModel.swift
//  TheOne
//
//  Created by lala on 2017/12/12.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct TaskDetailModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data:TaskDetailInfoModel?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct TaskDetailInfoModel: Mappable {
    
    var taskTitle: String = ""
    var taskModule: String = ""
    var taskLabel: String = ""
    var taskPriority: String = ""
    var taskStatus: String = ""
    var taskStartTime:String = ""
    var taskOverTime: String = ""
    var taskStartperson: String = ""
    var taskExecuteperson: String = ""
    var taskPlatform: String = ""
    var taskDescribe: String = ""
    var taskPhotos: String = ""
    var taskVoices: String = ""
    var taskPostpone: String = ""
    var record: [TaskRecordModel] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        taskTitle <- map["taskTitle"]
        taskModule <- map["taskModule"]
        taskLabel <- map["taskLabel"]
        taskPriority <- map["taskPriority"]
        taskStatus <- map["taskStatus"]
        taskStartTime <- map["taskStartTime"]
        taskOverTime <- map["taskOverTime"]
        taskStartperson <- map["taskStartperson"]
        taskExecuteperson <- map["taskExecuteperson"]
        taskPlatform <- map["taskPlatform"]
        taskDescribe <- map["taskDescribe"]
        taskPhotos <- map["taskPhotos"]
        taskVoices <- map["taskVoices"]
        taskPostpone <- map["taskPostpone"]
        record <- map["record"]
    }
}

struct TaskRecordModel: Mappable {
    
    var content: String = ""
    var handler: String = ""
    var createTime: String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        content <- map["content"]
        handler <- map["handler"]
        createTime <- map["createTime"]
    }
    
}
