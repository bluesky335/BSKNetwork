//
//  CMNetworkProtocols.swift
//  CMNetWork
//
//  Created by cmsy on 2018/5/17.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//



import Foundation
import Alamofire

public typealias Parameters = [String:Any]
public typealias Headers = [String:String]

/// 接口返回值类型
public enum APIResultDataType {
    case Text
    case Json
    case DATA
}

public enum APIScheme:String {
    case http = "http"
    case https = "https"
}

/// 接口请求发起前参数处理，校验，签名等
public protocol ParametersSignerProtocol{
    func sign(parameters:Parameters?) -> Parameters?
}

/// 处理接口返回值
public protocol ResultHandlerProtocol{
    func handle<R:Codable>(result:Any,type:R.Type,server:ServerProtocol,path:APIPath)throws->R
}


/// 接口路径及该路径的动作
public protocol APIPath{
    
    var parameters:Parameters?{get}
    var resaulDataType:APIResultDataType{get}
    var action:HTTPMethod{get}
    var Path:String{get}
    var headers:Headers?{get}

}

/// 定义了服务器的协议、主机地址、端口、参数签名器、返回结果检查器
public protocol ServerProtocol{
    var scheme:APIScheme{get}
    var host:String{get}
    var port:Int{get}
    var parameterSigner:ParametersSignerProtocol{get}
    var resaultHandler:ResultHandlerProtocol{get}
    
    func url(With Path:APIPath?) -> String
}

