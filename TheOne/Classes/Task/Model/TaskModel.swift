//
//  TaskModel.swift
//  TheOne
//
//  Created by lala on 2017/12/8.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct TaskModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data:[TaskListModel] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct TaskListModel: Mappable {
    
    var taskContent: String = ""
    var postpone: String = ""
    var startTime: String = ""
    var cutoffTime: String = ""
    var priority: String = ""
    var status: String = ""
    var taskId: String = ""
    var creater: String = ""
    var executePerson: String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        taskContent <- map["taskContent"]
        postpone <- map["postpone"]
        startTime <- map["startTime"]
        cutoffTime <- map["cutoffTime"]
        priority <- map["priority"]
        status <- map["status"]
        taskId <- map["taskId"]
        creater <- map["creater"]
        executePerson <- map["executePerson"]
    }
    
}

/* ============================= SectionModel =============================== */

struct TaskListSection {
    
    var items: [Item]
}

extension TaskListSection: SectionModelType {
    
    typealias Item = TaskListModel
    
    init(original: TaskListSection, items: [TaskListSection.Item]) {
        self = original
        self.items = items
    }
}
