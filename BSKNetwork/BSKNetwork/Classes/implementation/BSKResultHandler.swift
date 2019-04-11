//
//  CMResultHandler.swift
//  CMNetWork
//
//  Created by cmsy on 2018/5/21.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import UIKit

open class BSKResultHandler: ResultHandlerProtocol {
    public init() {}
    open func handle<R: Codable>(result: Any, type: R.Type, server: ServerProtocol, path: APIPath) throws -> R {
        return try type.decode(from: result)
    }
}
