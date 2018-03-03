//
//  ModelExtension.swift
//  TheOne
//
//  Created by lala on 2017/11/3.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result
import SwiftyJSON

extension Observable {
    
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard (dict["code"] as? Int) != nil else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            if let error = self.parseError(response: dict) {
                throw error
            }
            
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            guard let array = response as? [Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard (dict["status"] as?Int) != nil else{
                throw RxSwiftMoyaError.OtherError
            }
            if let error = self.parseError(response: dict) {
                throw error
            }
            
            return Mapper<T>().mapArray(JSONArray: dicts)
        }
    }
    
    func parseServerError() -> Observable {
        return self.map { (response) in
            let name = type(of: response)
            print(name)
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            if let error = self.parseError(response: dict) {
                throw error
            }
            return self as! Element
        }
        
    }
    
    fileprivate func parseError(response: [String: Any]?) -> NSError? {
        var error: NSError?
        if let value = response {
            var code:Int?
            
            
            if let codes = value["code"] as?Int
            {
                code = codes
                
            }
            if  code != 200 {
                var msg = ""
                if let message = value["message"] as? String {
                    msg = message
                }
                error = NSError(domain: "Network", code: code!, userInfo: [NSLocalizedDescriptionKey: msg])
            }
        }
        return error
    }
    
    
}

extension Response {
    
    // 这一个主要是将JSON解析为单个的Model
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
        
    }
    
    // 这个主要是将JSON解析成多个Model并返回一个数组，不同的json格式写法不相同
    public func mapArray<T: BaseMappable>(_ type: T.Type) throws -> [T] {

        let json = JSON(data: self.data)

        let jsonArray = json["data"]["data"]

        guard let array = jsonArray.arrayObject as? [[String: Any]]
             else {

            throw MoyaError.jsonMapping(self)
        }
        
        let objects = Mapper<T>().mapArray(JSONArray: array)
        
        return objects
    }
}

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// Maps data received from the signal into an object
    /// which implements the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    public func mapObject<T: BaseMappable>(_ type: T.Type, _ context: MapContext? = nil) -> Single<T> {
        
        
        
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(type), scheduler: CurrentThreadScheduler.instance)
        }
    }
    
    /// Maps data received from the signal into an array of objects
    /// which implement the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    public func mapArray<T: BaseMappable>(_ type: T.Type, _ context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(type), scheduler: CurrentThreadScheduler.instance)
        }
    }
}


enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error {
    
    
}
