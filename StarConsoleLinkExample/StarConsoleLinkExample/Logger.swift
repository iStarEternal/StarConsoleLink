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
    static let RESET = ESCAPE + ";"      // Clear any foreground or background color
}

let InfoColor = "22,22,22"          // 黑色
let InfoTitle = "Info"

let DebugColor = "28,0,207"         // 蓝色
let DebugTitle = "Debug"

let WarningColor = "218,130,53"     // 黄色
let WarningTitle = "Warning"

let ErrorColor = "196,26,22"        // 红色
let ErrorTitle = "Error"

let ImportantColor = "196,26,22"    // 红色
let ImportantTitle = "Important - 如果发现该行日志，应该及时处理"

let SuccessColor = "0,116,0"        // 绿色
let SuccessTitle = "Success"

let FailureColor = "196,26,22"      // 红色
let FailureTitle = "Failure"

let AssertColor = "196,26,22"       // 红色
let AssertTitle = "Assert"

let FatalErrorColor = "196,26,22"   // 红色
let FatalErrorTitle = "FatalError"



class Logger: NSObject {
    
    // WEIGHT: 0
    class func print<T>(value: T, title: String, color: String, functionName: String, fileName: String, lineNumber: Int) {
        Swift.print("\(LogColor.ESCAPE)fg\(color);[\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)\(LogColor.RESET)")
    }
    
    // WEIGHT: 0
    class func info<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: InfoTitle, color: InfoColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 0
    class func debug<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: DebugTitle, color: DebugColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 2
    class func warning<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: WarningTitle, color: WarningColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 4
    class func error<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: ErrorTitle, color: ErrorColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 5
    class func important<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: ImportantTitle, color: ImportantColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
}

// MARK: - Resoponse
extension Logger {
    
    // WEIGHT: 0
    class func success<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: SuccessTitle, color: SuccessColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 1
    class func failure<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: FailureTitle, color: FailureColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

// MARK: - Assert
extension Logger {
    
    // WEIGHT: 5+
    class func assertionFailure(value: String, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: AssertTitle, color: AssertColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.assertionFailure(value)
        
    }
    // WEIGHT: 5+
    class func assert(flag: Bool, value:String, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: AssertTitle, color: AssertColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.assert(flag)
    }
    // WEIGHT: 5+
    class func fatalError(value: String, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: FatalErrorTitle, color: FatalErrorColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.fatalError(value)
    }
    
}
