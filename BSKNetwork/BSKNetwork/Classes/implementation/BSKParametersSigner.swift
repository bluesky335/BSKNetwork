//
//  CMParametersSigner.swift
//  CMNetWork
//
//  Created by cmsy on 2018/5/21.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import Foundation
import Alamofire

public class BSKParametersSigner: ParametersSignerProtocol {
    public typealias SignerBlock = (_ parameters:Parameters?) -> Parameters?
    let signer:SignerBlock
    
    public init(signer:SignerBlock? = nil) {
        if let signer = signer{
            self.signer = signer
        }else{
            self.signer = {
                (parameters) in
                return parameters
            }
        }
    }
   public func sign(parameters: Parameters?) -> Parameters? {
        return self.signer(parameters)
    }
}
