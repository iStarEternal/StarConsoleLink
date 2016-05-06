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
let regularExpr = try! NSRegularExpression(pattern: "\\[(([\\w\\+\\-]+)\\.(\\w+):(\\d+))\\]", options: .CaseInsensitive)

struct StarConsoleLinkFieldName {
    static let linkFileName = "StarConsoleLink_FileName"
    static let linkLine = "StarConsoleLink_Line"
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
            self.injectLinks()
        }
    }
    
    
    
    private func injectLinks() {
        
        let matches = regularExpr.matchesInString(self.string, options: .ReportProgress, range: self.editedRange)
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
            
            self.addAttribute(StarConsoleLinkFieldName.linkFileName, value: "\(fileName).\(fileExtension)", range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.linkLine, value: line, range: linkRange)
            
            self.addAttribute(NSLinkAttributeName, value: link, range: linkRange)
            self.addAttribute(NSForegroundColorAttributeName, value: NSColor(rgb:0x0000ff), range: linkRange)
        }
        
    }
    
}