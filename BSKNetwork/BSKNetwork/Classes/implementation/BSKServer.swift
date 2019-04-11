//
//  CMSerVer.swift
//  CMNetWork
//
//  Created by cmsy on 2018/5/18.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import Foundation
import Alamofire

public class BSKServer:ServerProtocol {
    
    public let scheme:APIScheme
    public let host:String
    public let port:Int
    public let parameterSigner:ParametersSignerProtocol
    public let resaultHandler:ResultHandlerProtocol
    
    public init(scheme:APIScheme, host:String, port:Int = 80, parameterSigner:ParametersSignerProtocol? = nil, resaultHandler:ResultHandlerProtocol? = nil) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.parameterSigner = parameterSigner != nil ? parameterSigner!: BSKParametersSigner()
        self.resaultHandler = resaultHandler != nil ? resaultHandler!: BSKResultHandler()
    }
    
    public func url(With Path:APIPath?) -> String{
        if let Path = Path {
            var str = "/"
            if Path.Path.hasPrefix("/")||self.host.hasSuffix("/"){
                str = ""
            }
            return "\(self.scheme.rawValue)://\(self.host):\(self.port)\(str)\(Path.Path)"
        }else{
            return "\(self.scheme.rawValue)://\(self.host):\(self.port)"
        }
    }
}
