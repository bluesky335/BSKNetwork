//
//  BSKConsole.swift
//  BSKConsole
//
//  Created by cmsy on 2019/4/10.
//  Copyright © 2019 cn.liuwanlin. All rights reserved.
//

import UIKit

public class BSKConsole: NSObject {
    
    private static let lock = NSLock()
    
    public static func log(_ items:Any..., showInfo:Bool = true, file:String = #file, line:Int = #line ){
        #if DEBUG
        printLogString(tag: "📋", items, showInfo: showInfo, file: file, line: line)
        #endif
    }
    
    public static func warning(_ items:Any..., showInfo:Bool = true, file:String = #file, line:Int = #line ){
        #if DEBUG
        printLogString(tag: "⚠️", items, showInfo: showInfo, file: file, line: line)
        #endif
    }
    
    public static func error(_ items:Any..., showInfo:Bool = true, file:String = #file, line:Int = #line ){
        printLogString(tag: "❌", items, showInfo: showInfo, file: file, line: line)
    }
    
    private static func printLogString(tag:String, _ items:[Any], showInfo:Bool , file:String, line:Int ) {
        var strs = [String]()
        for item in items {
            strs.append(String(describing: item))
        }
        let printLog = strs.joined(separator: " ")
        let fileURL = URL(fileURLWithPath: file)
        let fileName = fileURL.lastPathComponent
        
        var logStr = "\n"
        if showInfo {
            logStr.append("\(tag)┌------\n")
            logStr.append("\(tag)┤ 文件:\(fileName) 第\(line)行 线程:\(Thread.current.description)\n")
            logStr.append("\(tag)┤ ")
        }else{
            logStr.append("\(tag)┤ ")
        }
        logStr.append(printLog.replacingOccurrences(of: "\n", with: "\n\(tag)┤ "))
        logStr.append("\n")
        if showInfo {
            logStr.append("\(tag)└------\n")
        }
        print(log: logStr)
    }
    
    private static func print(log:String){
            lock.lock()
            NSLog(log)
            lock.unlock()
        }
    
}
