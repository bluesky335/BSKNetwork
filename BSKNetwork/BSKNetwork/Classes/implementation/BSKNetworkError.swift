//
//  CMNetworkError.swift
//  CMNetWork
//
//  Created by cmsy on 2018/5/21.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import UIKit
import Alamofire

public struct BSKNetworkError:Error,CustomStringConvertible {

    public let URL: String
    public let parameters: [String : Any]?
    public let headers: [String : String]?
    public let extraErrorInfo:String?
    public let responseValue:Any?
    public let errorCode: Int
    public let errorMessage: String
    public let requestType:HTTPMethod

    /// 初始化一个错误
    ///
    /// - Parameters:
    ///   - message: 错误信息
    ///   - URL: 产生错误的URL
    ///   - parameters: 发生错误时的参数
    ///   - extraError: 额外的错误信息(一般是由Alamofire产生的错误)
    public init(message:String,requestType:HTTPMethod, URL:String , parameters: [String : Any]? = nil,headers:[String:String]? = nil, extraError:Error? = nil, responseValue:Any?) {
        self.URL = URL
        self.errorCode = -1
        self.parameters = parameters
        self.responseValue = responseValue
        self.headers = headers
        self.errorMessage = message
        self.requestType = requestType
        if let extraError = extraError {
            self.extraErrorInfo = extraError.localizedDescription
        }else{
            self.extraErrorInfo = nil
        }

    }
    
    
    public var description: String {
        var str =
        """
        {
        "requestType":\(self.requestType.rawValue),
        "code":\(errorCode),
        "message":\(errorMessage),
        "URL":\(URL),
        """
        if let parameters_ = parameters {
            let jsonData = (try? JSONSerialization.data(withJSONObject: parameters_, options: .prettyPrinted)) ?? Data()
            let jsonStr = String(data: jsonData, encoding: .utf8) ?? ""
            str.append("\n\"parameters\":\(jsonStr),")
        }
        
        if let headers = headers {
            let jsonData = (try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)) ?? Data()
            let jsonStr = String(data: jsonData, encoding: .utf8) ?? ""
            str.append("\n\"headers\":\(jsonStr),")
        }
        
        if let extraErrorInfo = extraErrorInfo {
            str.append("\n\"extraErrorInfo\":\(extraErrorInfo),")
        }
        
        if let responseValue = responseValue {
            str.append("\n\"responseValue\":\(responseValue)")
        }
        
        str.append("}")
        return str
    }
    
}
