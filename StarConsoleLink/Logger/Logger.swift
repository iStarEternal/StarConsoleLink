//
//  Logger.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation

// 控制是否启用日志打印
// 此处的DEBUG应该在target下 Build Settings 搜索 Other Swift Flags
// 设置Debug 添加 -D DEBUG，注意不要好Release一起添加
#if DEBUG
let StarDebug = true
#else
let StarDebug = false
#endif


struct LogColor {
    
    static let XcodeColors = true
    
    static let ESCAPE = "\u{001b}["
    static let ESCAPE_FG = "\u{001b}[fg"
    static let ESCAPE_BG = "\u{001b}[bg"
    
    static let RESET = ESCAPE + ";"      // Clear any foreground or background color
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
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

//#if swift(>=2.2)
// let functionName = #function
//#else
// let functionName = __FUNCTION__
//#endif

class Logger: NSObject {
    
    class func print<T>(value: T, title: String, color: String, functionName: String, fileName: String, lineNumber: Int) {
//        star_back_trace(4)
        guard StarDebug else {
            return
        }
        if LogColor.XcodeColors {
            Swift.print("\(LogColor.ESCAPE_FG)\(color);<\(current_time())> [\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)\(LogColor.RESET_FG)")
        }
        else {
            Swift.print("<\(current_time())> [\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)")
        }
    }
    
    class func info<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: InfoTitle, color: InfoColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func debug<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: DebugTitle, color: DebugColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func warning<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: WarningTitle, color: WarningColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func error<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: ErrorTitle, color: ErrorColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func important<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: ImportantTitle, color: ImportantColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    private static func current_time() -> String {
        let bufferSize = 255
        var buffer = [Int8](count: bufferSize, repeatedValue: 0)
        var rawtime = time(nil)
        let timeinfo = localtime(&rawtime)
        strftime(&buffer, 32, "%Y-%m-%d %H:%M:%S", timeinfo) // %B
        let datetime = String(CString: buffer, encoding: NSUTF8StringEncoding)!
        // free(buffer)
        return datetime
    }
    
    
    static func star_back_trace(depth: UInt) -> String {
        
        
        Swift.print(NSThread.callStackSymbols());
        
        
        //        void *callstack[128];
        //        int frames = backtrace(callstack, 128);
        //        char **strs = backtrace_symbols(callstack, frames);
        //
        //        memset(star_back_trace_str, 0, STAR_BACK_TRACE_BUFFER * sizeof(char));
        //        strcat(star_back_trace_str, "\n<BackTrace Begin>");
        //        for (int i = 1; i < frames; i++) {
        //            // if (strlen(star_back_trace_str) + strlen(strs[i]) + 16 > STAR_BACK_TRACE_BUFFER)
        //            //     break;
        //            strcat(star_back_trace_str, "\n\t");
        //            strcat(star_back_trace_str, strs[i]);
        //            if (i == depth)
        //            break;
        //        }
        //        strcat(star_back_trace_str, "\n<End>");
        //
        //        free(strs);
        //        strs = NULL;
        //
        //        return star_back_trace_str;
        return "";
    }
    
}

// MARK: - Resoponse
extension Logger {
    
    class func success<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: SuccessTitle, color: SuccessColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func failure<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: FailureTitle, color: FailureColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

// MARK: - Assert
extension Logger {
    
    class func assertionFailure(value: String, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: AssertTitle, color: AssertColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.assertionFailure(value)
        
    }
    
    class func assert(flag: Bool, value:String, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: AssertTitle, color: AssertColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.assert(flag)
    }
    
    class func fatalError(value: String, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: FatalErrorTitle, color: FatalErrorColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        Swift.fatalError(value)
    }
    
}
