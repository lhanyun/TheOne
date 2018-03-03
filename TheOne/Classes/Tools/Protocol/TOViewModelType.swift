//
//  TOViewModelType.swift
//  TheOne
//
//  Created by lala on 2017/11/14.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation

protocol TOViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}



