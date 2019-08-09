//
//  ViewController.swift
//  BSKNetwork
//
//  Created by bluesky335 on 04/10/2019.
//  Copyright (c) 2019 bluesky335. All rights reserved.
//

import UIKit
import BSKNetwork
import BSKConsole

class BaseServerResault<T:Codable>:Codable {
    var code:Int
    var message:String? = nil
    var data:T
    
}


//class BaseServerResault2:Codable {
//    var code:Int = 0
//    var message:String = ""
//    var data:Codable. x? = nil
//}

class TestObj:Codable {
    var name:String
    var age:Int
    var level:Int
}

class MyHandler: BSKResultHandler {
    override func handle<R:Codable>(result: Any, type: R.Type, server: ServerProtocol, path: APIPath) throws -> R {
        
        let model = try BaseServerResault<R>.decode(from: result)
        let info = [
            "URL":server.url(With: path),
            "action":"\(path.action)",
            "header":"\(String(describing: path.headers))",
            "parameters":"\(String(describing: path.parameters))"
        ]
        
        if model.code != 200 {
            throw NSError(domain: model.message ?? "no Message" , code: model.code, userInfo: info) as Error
        }
        if let data = model.data as? R {
            return data
        }
        throw NSError(domain: "数据为空" , code: model.code, userInfo: info) as Error
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let handler = MyHandler()
        BSKNetworkConfig.defaultServer = BSKServer(scheme: .http, host: "192.168.0.233", port: 80, parameterSigner: nil, resaultHandler: handler)
        
        let api = BSKApiPath(action: .get, parameters: nil, resaulDataType: .Json, Path: "testJson.json", headers: nil)
        
        BSKNetwork<TestObj?>.request(API: api, completeHandler: {
            a in
            switch a {
            case .success(let module):
                BSKConsole.log("网络请求成功")
                BSKConsole.log(module?.name ?? "nill")
            case .fail(let error):
                BSKConsole.error("网络请求失败")
                BSKConsole.error(error.localizedDescription)
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

