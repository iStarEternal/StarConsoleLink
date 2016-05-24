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
let RegularFileNameLineExpr = try! NSRegularExpression(pattern: "\\[(([\\w\\+\\-]+)\\.(\\w+):(\\d+))\\]", options: .CaseInsensitive)

// ([\+\-])     匹配OC方法的类型
// \[           匹配[开头的
// ([\w\+\-]+)  匹配文件名，包含+号-号
// \            匹配文件名中的空格
// ([\w\:]+)    匹配后缀
// \]           匹配]结尾的
let RegularFileNameMethodExpr = try! NSRegularExpression(pattern: "([\\+\\-])\\[(([\\w\\+\\-]+) ([\\w\\:]+))\\]", options: .CaseInsensitive)

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
            objc_setAssociatedObject(self, &UsedInConsoleKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func star_fixAttributesInRange(range: NSRange) {
        star_fixAttributesInRange(range)
        if self.usedInConsole {
            LogColorKit.applyANSIColors(self, textStorageRange: range, escapeSeq: XCODE_COLORS_ESCAPE)
            self.injectNormalLinks()
            self.injectBackTraceLinks()
        }
    }
    
    
    
    private func injectNormalLinks() {
        
        let matches = RegularFileNameLineExpr.matchesInString(self.string, options: .ReportProgress, range: self.editedRange)
        for result in matches where result.numberOfRanges == 5 {
            
            let ocText = self.string.OCString
            
            // let fullRange = result.rangeAtIndex(0)
            let linkRange = result.rangeAtIndex(1)
            let link = ocText.substringWithRange(linkRange)
            
            let fileNameRange = result.rangeAtIndex(2)
            let fileName = ocText.substringWithRange(fileNameRange)
            
            let fileExtensionRange = result.rangeAtIndex(3)
            let fileExtension = ocText.substringWithRange(fileExtensionRange)
            
            let lineRange = result.rangeAtIndex(4)
            let line = ocText.substringWithRange(lineRange)
            
            self.addAttribute(StarConsoleLinkFieldName.flag, value: "1", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.fileName, value: "\(fileName).\(fileExtension)", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.line, value: line, range: linkRange)
            
            self.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
            self.addAttribute(NSForegroundColorAttributeName, value: ConsoleLinkConfig.linkColor, range: linkRange)
        }
        
    }
    
    private func injectBackTraceLinks() {
        
        let matches = RegularFileNameMethodExpr.matchesInString(self.string, options: .ReportProgress, range: self.editedRange)
        for result in matches where result.numberOfRanges == 5 {
            
            let ocText = self.string.OCString
            
            let fullRange = result.rangeAtIndex(0)
            let fullText = ocText.substringWithRange(fullRange)
            Logger.error(fullText)
            
            let methodTypeRange = result.rangeAtIndex(1)
            let methodType = ocText.substringWithRange(methodTypeRange)
            
            let linkRange = result.rangeAtIndex(2)
            let link = ocText.substringWithRange(linkRange)
            
            let fileNameRange = result.rangeAtIndex(3)
            let fileName = ocText.substringWithRange(fileNameRange)
            
            let methodNameRange = result.rangeAtIndex(4)
            let methodName = ocText.substringWithRange(methodNameRange)
            
            self.addAttribute(StarConsoleLinkFieldName.flag, value: "2", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.methodType, value:methodType, range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.fileName, value:fileName, range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.methodName, value:methodName, range: linkRange)
            
            self.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
            self.addAttribute(NSForegroundColorAttributeName, value: ConsoleLinkConfig.linkColor, range: linkRange)
        }
        
    }
    
}