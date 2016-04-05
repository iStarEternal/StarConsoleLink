//
//  Logger.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation


struct LogColor {
    
    static let ESCAPE = "\u{001b}["
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"   // Clear any foreground or background color
}

class Logger: NSObject {
    
    class func print<T>(value: T, title: String, color: String, functionName: String, fileName: String, lineNumber: Int) {
        
        Swift.print("\(LogColor.ESCAPE)fg\(color);[\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)\(LogColor.RESET)")
    }
    
    // WEIGHT: 0
    class func debug<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        //        guard DEBUG != 0 else {
        //            return
        //        }
        print(value, title: "Debug", color: "0,0,255", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 0
    class func info<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Info", color: "11,11,11", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 2
    class func warning<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Warning", color: "244,189,10", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 4
    class func error<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Error", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 5
    class func important<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Important][如果发现该行日志，应该及时处理", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
}

// MARK: - Resoponse
extension Logger {
    
    // WEIGHT: 0
    class func success<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Success", color: "0,153,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 1
    class func failure<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Failure", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

// MARK: - Assert
extension Logger {
    
    // WEIGHT: 5+
    class func assertionFailure(value: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        
        print(value, title: "Assert", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.assertionFailure(value)
        
    }
    // WEIGHT: 5+
    class func assert(flag: Bool, value:String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "Assert", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.assert(flag)
        
    }
    // WEIGHT: 5+
    class func fatalError(value: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: "FatalError", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.fatalError(value)
    }
    
}
