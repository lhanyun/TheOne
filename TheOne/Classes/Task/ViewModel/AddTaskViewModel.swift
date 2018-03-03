//
//  AddTaskViewModel.swift
//  TheOne
//
//  Created by lala on 2018/1/31.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class AddTaskViewModel {
    
    func submitTask(_ addTaskVC: TOAddTaskViewController, _ dataSource: [String: String]) {
        
        for (key, value) in dataSource {
            if !(key == "voices" ||
                key == "photos" ||
                key == "platform" ||
                key == "describeTask" ||
                key == "taskId") {
                if value.count == 0 {
                    TipHUD.sharedInstance.showTips("请将参数" + key + "填写完整")
                    return
                }
            }
        }
        
        let i = Tools().compareTime(dataSource["startTime"]!, dataSource["cutoffTime"]!)
        if i == 1 || i == 2 {
            
            TipHUD.sharedInstance.showTips("请正确选择任务的开始时间及截止时间")
            return
        }
        
        var token:APIManager = .editTask(dic: dataSource)
        
        if dataSource["taskId"]?.count == 0 {
            
            token = .createTask(dic: dataSource)
        }
        
        provider.rx.request(token)
            .mapObject(RegisterModel.self)
            .subscribe { (event) in
                
                switch event {
                case .success(let model):
                    
                    if model.code == 200 {
                        
                        addTaskVC.recoder.delegate = nil
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshTaskList"), object: nil)
                        addTaskVC.navigationController?.popViewController(animated: true)
                    }
                    
                    TipHUD.sharedInstance.showTips(model.codeMsg)
                    
                case .error(let error):
                    
                    log.debug(error)
                }
            }
            .disposed(by: addTaskVC.rx.disposeBag)
    }
    
    //图片上传
    func uploadImg(data: Data, fileName: String, fileType:String = "", uploadProgress:@escaping (_ progress: Double)->(), complete:@escaping ( _ success: Bool, _ result: String)->()) {
        
        providerI.request(.uploadFile(fileName: fileName, fileType: fileType, fileData:data), callbackQueue: nil, progress: { (p) in
            //上传进度
            print("当前进度: \(p.progress)")
            uploadProgress(p.progress)
            
        }) { (result) in
            
            if case let .success(response) = result {
                
                //解析数据
                guard let data = JSON(response.data).dictionaryObject else {return}

                if (data["code"] as! Int) == 200 {
                    
                    let urls: [String] = data["data"] as! [String]
                    complete(true, urls[0])
                    log.debug(data["data"])
                } else {
                    complete(false, "")
                }
                
            } else {
                complete(false, "")
            }
        }
        
//        providerI.request( .uploadFile(fileName: "String", fileType: ".png", fileData:data), progress:{ p in
//                    //上传进度
//                    print("当前进度: \(p.progress)")
//                    uploadProgress(p.progress, true, "")
//            }) { result in
//
//
//        }
      
    }
}
