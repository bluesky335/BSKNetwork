//
// Created by cmsy on 2018/5/18.
// Copyright (c) 2018 ChaungMiKeJi. All rights reserved.
//

import Alamofire
import BSKConsole
import Foundation

public enum Result<ResultType> {
    case success(data:ResultType)
    case fail(error:Error)
}

public class BSKNetworkConfig {
    private init() {}

    public static var defaultServer: ServerProtocol = BSKServer(scheme: .http,
                                                                host: "www.baidu.com",
                                                                port: 80,
                                                                parameterSigner: BSKParametersSigner(),
                                                                resaultHandler: BSKResultHandler())
}

public class BSKNetwork<Type: Codable> {
    private init() {}

    @discardableResult
    public class func request(Server: ServerProtocol = BSKNetworkConfig.defaultServer,
                                  API: APIPath,
                                  completeHandler: @escaping (Result<Type>) -> Void,
                                  queue: DispatchQueue? = nil,
                                  file: String = #file,
                                  line: Int = #line) -> DataRequest {
        
        let url = Server.url(With: API)
        let parameters = Server.parameterSigner.sign(parameters: API.parameters)
        let request = Alamofire.request(url, method: API.action, parameters: parameters, headers: API.headers)
        switch API.resaulDataType {
        case .Text:
            request.responseString(queue: queue, completionHandler: { response in
                if let error = response.error {
                    let netError = BSKNetworkError(message: "网络请求失败", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError: error, responseValue: response.value)
                    BSKConsole.error(netError, file: file, line: line)
                    completeHandler(Result.fail(error:netError))
                } else {
                    if let str = response.value {
                        if let result = str as? Type {
                            completeHandler(Result.success(data:result))
                        } else {
                            let netError = BSKNetworkError(message: "API要求的返回类型是 Text/String 但BSKNetwork<Type>泛型给定的类型是 \(String(describing: Type.self))", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError: nil, responseValue: response.value)
                            BSKConsole.error(netError, file: file, line: line)
                            completeHandler(Result.fail(error:netError))
                        }
                    } else {
                        let netError = BSKNetworkError(message: "返回的数据为空", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError: nil, responseValue: response.value)
                        BSKConsole.error(netError, file: file, line: line)
                        completeHandler(Result.fail(error:netError))
                    }
                }
            })
        case .Json:
            request.responseJSON(queue: queue) { response in
                if let error = response.error {
                    let netError = BSKNetworkError(message: "网络请求失败", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError:
                        error, responseValue: response.value)
                    BSKConsole.error(netError, file: file, line: line)
                    completeHandler(Result.fail(error:netError))
                } else {
                    if let value = response.value, !(value is NSNull) {
                        do {
                            let resultValue = try Server.resaultHandler.handle(result: value, type: Type.self, server: Server, path: API)

                            completeHandler(Result.success(data:resultValue))

                        } catch {
                            BSKConsole.error(error)
                            completeHandler(Result.fail(error:error))
                        }
                    } else {
                        let netError = BSKNetworkError(message: "返回的数据为空", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError:
                            nil, responseValue: response.value)
                        BSKConsole.error(netError, file: file, line: line)
                        completeHandler(Result.fail(error:netError))
                    }
                }
            }
        case .DATA:
            request.responseData(queue: queue) { response in
                if let error = response.error {
                    let netError = BSKNetworkError(message: "网络请求失败", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError:
                        error, responseValue: response.value)
                    BSKConsole.error(netError, file: file, line: line)
                    completeHandler(Result.fail(error:netError))
                } else {
                    if let value = response.value {
                        if let resultData = value as? Type {
                            completeHandler(Result.success(data:resultData))
                        } else {
                            let netError = BSKNetworkError(message: "API要求的返回类型是 Data 但BSKNetwork<Type>泛型给定的类型是 \(String(describing: Type.self))", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError: nil, responseValue: response.value)
                            BSKConsole.error(netError, file: file, line: line)
                            completeHandler(Result.fail(error:netError))
                        }
                    } else {
                        let netError = BSKNetworkError(message: "返回的数据为空", requestType: API.action, URL: url, parameters: parameters, headers: API.headers, extraError:
                            nil, responseValue: response.value)
                        BSKConsole.error(netError, file: file, line: line)
                        completeHandler(Result.fail(error:netError))
                    }
                }
            }
        }
        return request
    }
}
