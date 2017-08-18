//
//  NSTextStorage-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa



// used
var UsedInConsoleKey = "Mark.By.Star.isUsedInXcodeConsole"

// XcodeColors escape
let XCODE_COLORS_ESCAPE = "\u{001b}["

// \[           匹配[开头的
// ([\w\+\-]+)  匹配文件名，包含+号-号
// \.           匹配文件名中的点
// (\w+)        匹配后缀
// :            匹配冒号
// (\d+)        匹配行号
// \]           匹配]结尾的
let RegularFileNameLineExpr = try! NSRegularExpression(pattern: "\\[(([\\w\\+\\-]+)\\.(\\w+):(\\d+))\\]", options: .caseInsensitive)

// ([\+\-])     匹配OC方法的类型
// \[           匹配[开头的
// ([\w\+\-]+)  匹配文件名，包含+号-号
// \            匹配文件名中的空格
// ([\w\:]+)    匹配后缀
// \]           匹配]结尾的
let RegularFileNameMethodExpr = try! NSRegularExpression(pattern: "([\\+\\-])\\[(([\\w\\+\\-]+) ([\\w\\:]+))\\]", options: .caseInsensitive)

struct StarConsoleLinkFieldName {
    static let flag = "Star.StarConsoleLink.Flag"
    static let fileName = "Star.StarConsoleLink.FileName"
    static let line = "Star.StarConsoleLink.Line"
    static let methodName = "Star.StarConsoleLink.MethodName"
    static let methodType = "Star.StarConsoleLink.MethodType"
}


extension NSTextStorage {
    
    
    var usedInConsole: Bool {
        get {
            return (objc_getAssociatedObject(self, &UsedInConsoleKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &UsedInConsoleKey, NSNumber(value: newValue as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func star_fixAttributesInRange(_ range: NSRange) {
        star_fixAttributesInRange(range)
        if usedInConsole && ConsoleLinkConfig.consoleLinkEnabled {
            LogColorKit.applyANSIColors(self, textStorageRange: range, escapeSeq: XCODE_COLORS_ESCAPE)
            self.injectNormalLinks()
            self.injectBackTraceLinks()
        }
    }
    
    
    fileprivate func injectNormalLinks() {
        
        let matches = RegularFileNameLineExpr.matches(in: self.string, options: .reportProgress, range: self.editedRange)
        for result in matches where result.numberOfRanges == 5 {
            
            let ocText = self.string.OCString
            
            // let fullRange = result.rangeAtIndex(0)
            let linkRange = result.rangeAt(1)
            let link = ocText.substring(with: linkRange)
            
            let fileNameRange = result.rangeAt(2)
            let fileName = ocText.substring(with: fileNameRange)
            
            let fileExtensionRange = result.rangeAt(3)
            let fileExtension = ocText.substring(with: fileExtensionRange)
            
            let lineRange = result.rangeAt(4)
            let line = ocText.substring(with: lineRange)
            
            self.addAttribute(StarConsoleLinkFieldName.flag, value: "1", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.fileName, value: "\(fileName).\(fileExtension)", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.line, value: line, range: linkRange)
            
            self.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
            self.addAttribute(NSForegroundColorAttributeName, value: ConsoleLinkConfig.linkColor, range: linkRange)
        }
        
    }
    
    fileprivate func injectBackTraceLinks() {
        
        let matches = RegularFileNameMethodExpr.matches(in: self.string, options: .reportProgress, range: self.editedRange)
        for result in matches where result.numberOfRanges == 5 {
            
            let ocText = self.string.OCString
            
            let fullRange = result.rangeAt(0)
            let fullText = ocText.substring(with: fullRange)
            Logger.error(fullText)
            
            let methodTypeRange = result.rangeAt(1)
            let methodType = ocText.substring(with: methodTypeRange)
            
            let linkRange = result.rangeAt(2)
            let link = ocText.substring(with: linkRange)
            
            let fileNameRange = result.rangeAt(3)
            let fileName = ocText.substring(with: fileNameRange)
            
            let methodNameRange = result.rangeAt(4)
            let methodName = ocText.substring(with: methodNameRange)
            
            self.addAttribute(StarConsoleLinkFieldName.flag, value: "2", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.methodType, value:methodType, range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.fileName, value:fileName, range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.methodName, value:methodName, range: linkRange)
            
            self.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
            self.addAttribute(NSForegroundColorAttributeName, value: ConsoleLinkConfig.linkColor, range: linkRange)
        }
        
    }
    
}
