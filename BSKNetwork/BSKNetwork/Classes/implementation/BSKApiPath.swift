//
//  BSKApiPath.swift
//  BSKNetwork
//
//  Created by cmsy on 2019/4/11.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import Alamofire
import UIKit

public struct BSKApiPath: APIPath {
    /// 网络请求的方式
    public var action: HTTPMethod

    /// 请求参数
    public var parameters: Parameters?

    /// 返回数据类型
    public var resaulDataType: APIResultDataType

    /// 网络请求的路径地址
    public var Path: String

    /// header信息
    public var headers: Headers?

    public init(action: HTTPMethod = .get, parameters: Parameters?, resaulDataType: APIResultDataType = .Json, Path: String, headers: Headers? = nil) {
        self.action = action
        self.parameters = parameters
        self.resaulDataType = resaulDataType
        self.Path = Path
        self.headers = headers
    }
}
