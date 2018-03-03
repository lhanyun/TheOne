//
//  MemberModel.swift
//  TheOne
//
//  Created by lala on 2017/11/30.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct MemberModel: Mappable {
    
    var code:Int = 0
    var codeMsg: String = ""
    var data:[UserInfo] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        codeMsg <- map["codeMsg"]
        data <- map["data"]
    }
}

struct MemberListModel: Mappable {
    
    var name:String = ""
    var memberId:String = ""
    var imgUrl:String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        memberId <- map["memberId"]
        imgUrl <- map["imgUrl"]
    }
    
}

/* ============================= SectionModel =============================== */

struct MemberListSection {
    
    var items: [Item]
}

extension MemberListSection: SectionModelType {
    
    typealias Item = UserInfo
    
    init(original: MemberListSection, items: [MemberListSection.Item]) {
        self = original
        self.items = items
    }
}
