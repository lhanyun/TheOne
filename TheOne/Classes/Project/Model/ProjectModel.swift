//
//  ProjectModel.swift
//  TheOne
//
//  Created by lala on 2017/11/14.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct ProjectModel: Mappable {
    
    var code: Int = 0
    var codeMsg: String = ""
    var data:[ProjectListModel] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct ProjectListModel: Mappable {
    
    var projectName:String = ""
    var projectId:String = ""
    var creater:String = ""
    var postpone:String = ""
    var projectStatus:String = ""
    var createTime:String = ""
    var endTime:String = ""
    var projectModules:String = ""
    var userModule:String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        
        projectName <- map["projectName"]
        creater <- map["creater"]
        postpone <- map["postpone"]
        projectStatus <- map["projectStatus"]
        createTime <- map["createTime"]
        projectId <- map["projectId"]
        endTime <- map["endTime"]
        projectModules <- map["projectModules"]
        userModule <- map["userModule"]
    }
    
}



/* ============================= SectionModel ======================== */

struct ProjectListSection {
    
    var items: [Item]
}

extension ProjectListSection: SectionModelType {
    
    typealias Item = ProjectListModel
    
    init(original: ProjectListSection, items: [ProjectListSection.Item]) {
        self = original
        self.items = items
    }
}
