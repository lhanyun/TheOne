//
//  NetWork.swift
//  TheOne
//
//  Created by lala on 2017/11/7.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

struct Network {
    
//    static let provider = MoyaProvider<APIManager>()
    
    static func request(
        _ target: APIManager,
        provider: MoyaProvider<APIManager>,
        model: Mappable,
        success successCallback: @escaping (Mappable) -> Void,
        error errorCallback: @escaping (Int) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void
        ) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    //如果数据返回成功则直接将结果转为Model
                    let model = try response.filterSuccessfulStatusCodes().mapObject(LoginModel.self)
                    successCallback(model)
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    errorCallback((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //如果连接异常，则返回错误信息（必要时还可以将尝试重新发起请求）
                //if target.shouldRetry {
                //    retryWhenReachable(target, successCallback, errorCallback,
                //      failureCallback)
                //}
                //else {
                failureCallback(error)
                //}
            }
        }
    }
}
