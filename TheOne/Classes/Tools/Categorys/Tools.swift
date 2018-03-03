//
//  Tools.swift
//  TheOne
//
//  Created by lala on 2018/1/18.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import Foundation
import FileKit
import ObjectMapper
import SwiftyJSON

class Tools {
    
    var userInfo: UserInfo {
        set {

            let info = newValue.toJSON()
            let data = try? JSONSerialization.data(withJSONObject: info, options: []) as Data
            //写入磁盘
            let path = Path.userDocuments + "userInfo.json"
//            try? data?.write(to: path, options: .atomicWrite)
            try? data?.write(to: path)
        }
        
        get {
            let path = Path.userDocuments + "userInfo.json"
            let data = try? Data.read(from: path)
            
            let json = JSON(data: data ?? Data()).dictionaryObject ?? ["": ""]
            
            return Mapper<UserInfo>().map(JSON: json)!
        }
    }
    
    //更新userInfo的值
    func updataUserInfo(_ dic: [String: String]) {
        
        var u = userInfo.toJSON()
        
        for key in dic.keys {
            
            guard let str: String = dic[key] else {
                
                TipHUD.sharedInstance.showTips("值必须为字符串")
                log.debug("值必须为字符串")
                return
            }
            
            u[key] = str
        }
        
        userInfo = Mapper<UserInfo>().map(JSON: u)!
    }
    
    func isTelNumber(num: String) -> Bool {
        
        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        
        let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if ((regextestmobile.evaluate(with: num) == true) || (regextestcm.evaluate(with: num)  == true) || (regextestct.evaluate(with: num) == true) || (regextestcu.evaluate(with: num) == true)) {
            
            return true
        } else {
            
            return false
        }
        
    }
    
    //允许大小写或数字(不限字数)
    func judgeTheillegalCharacter(character: String) -> Bool {
    
        let regex = "[a-zA-Z0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let inputString = predicate.evaluate(with: character)
        return inputString
    }
    
    

}

//
extension Tools {
    
    //和今天的时间比较大小
    func compareTimeWithToday(_ time: String) -> Int {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let toDayStr = formatter.string(from: Date())
        
        return compareTime(time, toDayStr)
    }
    
    //比较时间大小
    func compareTime(_ fristTime: String, _ secondTime: String) -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "Asia/Shanghai")! as TimeZone
        guard let date1 = formatter.date(from: fristTime),
            let date2 = formatter.date(from: secondTime) else {
                
                log.debug("传入时间字符串格式不对")
                return 2
        }
        
        let result:ComparisonResult = date1.compare(date2)
        
        if result == ComparisonResult.orderedDescending {
            print("date2 <= date1") // 1
        } else if result == ComparisonResult.orderedSame {
            print("date2 = date1")  // 0
        } else if result == ComparisonResult.orderedAscending {
            print("date2 >= date1") // -1
        }
        
        return result.rawValue
    }
    
    //获取距当日相差多少天
    func getDifferenceByDateWithToday(_ fristTime: String) -> NSInteger {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let toDayStr = formatter.string(from: Date())
        
        return getDifferenceByDate(fristTime, toDayStr)
    }
    
    //获取两个时间相差多少天
    func getDifferenceByDate(_ fristTime: String, _ secondTime: String) -> NSInteger {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let now = formatter.date(from: fristTime),
        let oldDate = formatter.date(from: secondTime) else {
            
            return -1
        }
        
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        
        guard let comps = gregorian?.components(.day, from: now, to: oldDate, options: []) else { return -1 }
        
        return comps.day ?? -1
    }
    
}
