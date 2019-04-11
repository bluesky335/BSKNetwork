//
//  CodeableExtension.swift
//  BSKNetwork
//
//  Created by cmsy on 2019/4/10.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import BSKConsole
import UIKit

private struct BSKCodeableError: Error {
    var message: String
}

extension Decodable {
    
    
    public static func decode(from json: Any?) throws ->Self{
        var tempError:Error? = nil
        let returnValue = decode(from: json, onError: { (aError) in
            tempError = aError
        })
        if tempError != nil {
            throw tempError!
        }
        if returnValue == nil {
            throw BSKCodeableError(message: "解码失败")
        }
        return returnValue!
    }
    
    public static func tryDecode(from json: Any?,error:inout Error?) ->Self?{
        var tempError:Error? = nil
        let returnValue = decode(from: json, onError: { (aError) in
            tempError = aError
        })
        error = tempError
        return returnValue
    }
    
    public static func tryDecode(from json: Any?) ->Self?{
        return decode(from: json, onError: nil)
    }
    
    private static func decode(from json: Any?, onError: ((Error) -> Void)?) -> Self? {
        guard let ajson = json else {
            let error = BSKCodeableError(message: "数据为空")
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }

        if let jsonStr = ajson as? String {
            return decode(from: jsonStr, onError: onError)
        } else if let jsonData = ajson as? Data {
            return decode(from: jsonData, onError: onError)
        } else if let jsonDic = ajson as? [String: Any] {
            return decode(from: jsonDic, onError: onError)
        } else {
            do {
                let data = try JSONSerialization.data(withJSONObject: ajson, options: .prettyPrinted)
                return decode(from: data, onError: onError)
            } catch let error {
                if onError != nil {
                    onError?(error)
                } else {
                    BSKConsole.error(error)
                }
            }
        }
        return nil
    }

    private static func decode(from json: Data?, onError: ((Error) -> Void)? = nil) -> Self? {
        guard let json = json else {
            let error = BSKCodeableError(message: "数据为空")
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }
        do {
            return try JSONDecoder().decode(Self.self, from: json)
        } catch let error {
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }
    }

    private static func decode(from json: String?, onError: ((Error) -> Void)? = nil) -> Self? {
        guard let json = json else {
            let error = BSKCodeableError(message: "数据为空")
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }
        guard let data = json.data(using: .utf8) else {
            let error = BSKCodeableError(message: "解码失败")
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch let error {
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }
    }

    private static func decode(from json: [String: Any]?, onError: ((Error) -> Void)? = nil) -> Self? {
        guard let json = json else {
            let error = BSKCodeableError(message: "数据为空")
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
            
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return try JSONDecoder().decode(Self.self, from: data)
        } catch let error {
            if onError != nil {
                onError?(error)
            } else {
                BSKConsole.error(error)
            }
            return nil
        }
    }
}

extension Encodable {
    public var jsonData: Data? {
        let encoder = JSONEncoder()
        #if DEBUG
            encoder.outputFormatting = .prettyPrinted
        #endif
        return try? encoder.encode(self)
    }

    public var jsonStr: String? {
        if let data = self.jsonData {
            let str = String(data: data, encoding: .utf8)
            return str
        }
        return nil
    }

    public var jsonDic: [String: Any]? {
        guard let data = self.jsonData else { return nil }
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return nil }
        return dic as? [String: Any]
    }
}

extension CustomStringConvertible where Self: Codable {
    public var description: String {
        return jsonStr ?? "<error>"
    }
}

extension Dictionary {
    public var jsonStr: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch let error {
            return error.localizedDescription
        }
    }
}
