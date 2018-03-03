//
//  APIManager.swift
//  TheOne
//
//  Created by lala on 2017/11/3.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum APIManager {
    
    case editProject(dic: [String: Any])
    case validateUsername(username: String)
    case register(username: String, password: String, nickname: String, phone: String)
    case projectList(index: Int, limit: Int)
    case createProject(dic: [String: Any])
    case deleteProject(projectId:String)
    case resetPassword(username: String, password: String, phone: String)
    case login(username: String, password: String)
    case member(projectId: String, isShow: String)
    case tasklist(index: Int, limit: Int, projectId: String, taskLabel: String, sort: String, forMe: String, search: String)
    case detailProject(projectId: String)
    case createTask(dic: [String: Any])
    case editTask(dic: [String: Any])
    case detailTask(taskId: String)
    case uploadFile(fileName: String, fileType: String, fileData:Data)
    case deleteTask(taskId: String)
    case chooseTaskStatus(taskId: String, status: String)
    case doPraise(taskId: String, projectId: String, userName: String, praise: String)
    
    case getUserInfo
    case userInfoEdit(projectId: String, index: String, nickName: String, role: String, phoneNum: String, eMail: String, module: String)
    case getUserCurrentInfo(projectId: String)
    
    case downloadFile
    case getProjectFiles(projectId: String)
}

extension APIManager:TargetType {

    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8888")!
//        return URL(string: "http://perfectservice.free.ngrok.cc")!
    }
    
    var path: String {
        switch self {
        case .validateUsername:
            return "/validateUsername"
        case .register:
            return "/register"
        case .resetPassword:
            return "/resetPassword"
        case .login:
            return "/login"
            
        case .projectList:
            return "/getProjectList"
        case .createProject:
            return "/createProject"
        case .deleteProject:
            return "/deleteProject"
        case .editProject:
            return "/editProject"
        case .detailProject:
            return "/detailProjectList"
        
        case .member:
            return "/getMember"
        case .uploadFile:
            return "/uploadFile"
            
        case .editTask:
            return "/editTask"
        case .detailTask:
            return "/detailTask"
        case .createTask:
            return "/createTask"
        case .tasklist:
            return "/tasklist"
        case .deleteTask:
            return "/deleteTask"
        case .chooseTaskStatus:
            return "/chooseTaskStatus"
        case .doPraise:
            return "/doPraise"
            
        case .getUserInfo:
            return "/getUserInfo"
        case .userInfoEdit:
            return "/editUserInfo"
        case .getUserCurrentInfo:
            return "/getUserCurrentInfo"
            
        case .downloadFile:
            return "/downloadFile"
        case .getProjectFiles:
            return "/getProjectFiles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validateUsername:
            return .get
        default:
            return .post
//        case .register:
//            return .post
//        case .resetPassword:
//            return .post
//        case .projectList:
//            return .post
//        case .createProject:
//            return .post
//        case .deleteProject:
//            return .post
//        case .login:
//            return .post
//        case .editProject:
//            return .post
//        case .member:
//            return .post
//        case .tasklist:
//            return .post
//        case .detailProject:
//            return .post
//        case .createTask:
//            return .post
//        case .editTask:
//            return .post
//        case .uploadFile:
//            return .post
//        case .detailTask:
//            return .post
//        case .deleteTask:
//            return .post
//        case .chooseTaskStatus:
//            return .post
        }
    
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .validateUsername(let username):
            return self.settingParameter(param: ["username": username])
        case .register(let username, let password, let nickname, let phone):
            return self.settingParameter(param: ["username": username, "password": password, "nickname": nickname, "phone": phone])
        case .resetPassword(let username, let password, let phone):
            return self.settingParameter(param: ["username": username, "password": password,  "phone": phone])
        case .projectList(let index, let limit):
            return self.settingParameter(param: ["index": index, "limit": limit])
        case .createProject(let dic):
            return self.settingParameter(param: dic)
        case .login(let username, let password):
            return self.settingParameter(param: ["username": username,"password": password])
        case .editProject(let dic):
            return self.settingParameter(param: dic)
        case .member(let projectId, let isShow):
            return self.settingParameter(param: ["projectId": projectId, "isShow": isShow])
        case .tasklist(let index, let limit, let projectId, let taskLabel, let sort, let forMe, let search):
            return self.settingParameter(param: ["index": index, "limit": limit, "projectId": projectId, "taskLabel": taskLabel, "sort": sort, "forMe": forMe, "search": search])
        case .deleteProject(let projectId):
            return self.settingParameter(param: ["projectId": projectId])
        case .detailProject(let projectId):
            return self.settingParameter(param: ["projectId": projectId])
        case .editTask(let dic):
            return self.settingParameter(param: dic)
        case .createTask(let dic):
            return self.settingParameter(param: dic)
        case .uploadFile:
            return nil
        case .detailTask(let taskId):
            return self.settingParameter(param: ["taskId": taskId])
        case .deleteTask(let taskId):
            return self.settingParameter(param: ["taskId": taskId])
        case .chooseTaskStatus(let taskId, let status):
            return self.settingParameter(param: ["taskId": taskId, "status": status])
        case .doPraise(let taskId, let projectId, let userName, let praise):
            return self.settingParameter(param: ["taskId": taskId, "projectId": projectId, "userName": userName, "praise": praise])
            
        case .getUserInfo:
            return nil
        case .userInfoEdit(let projectId, let index, let nickName, let role, let phoneNum, let eMail, let module):
            return self.settingParameter(param: ["role": role, "projectId": projectId, "index": index, "nickName": nickName, "eMail": eMail, "module": module, "phoneNum": phoneNum])
        case .getUserCurrentInfo(let projectId):
            return self.settingParameter(param: ["projectId": projectId])
            
        case .downloadFile:
            return nil
        case .getProjectFiles(let projectId):
            return self.settingParameter(param: ["projectId": projectId])
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        
        switch self {
        case let .uploadFile(fileName, fileType, fileData):
            
            let formData = MultipartFormData(provider: .data(fileData), name: "uploadImg",
                                              fileName: fileName, mimeType: fileType)
            return .uploadMultipart([formData])
        default:
            return .requestParameters(parameters: self.parameters ?? [:], encoding: URLEncoding.default)
        }
        
    }

}


// MARK: - 处理基础参数 、 基础配置
extension APIManager {
    
    func settingParameter(param: [String : Any]) -> [String : Any] {
        
        //初始化一个字典
        var params:[String : Any] = [:]
        
        //将基础参数和页面参数合并
        for (key, value) in param {
            
            //将值处理成json字符串，方便后台处理
            let p = JSON(value)
            params[key] = p
        }
        
        return params
    }
    
}
