//
//  NSTextStorage-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa

struct AssociatedKeys {
    static var isConsoleKey = "isConsoleKey"
}

struct StarConsoleLinkFieldName {
    static let linkFileName = "StarConsoleLink_FileName"
    static let linkLine = "StarConsoleLink_Line"
}

extension NSTextStorage {
    
    var usedInConsole: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.isConsoleKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isConsoleKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func star_fixAttributesInRange(range: NSRange) {
        star_fixAttributesInRange(range)
        if self.usedInConsole {
            applyANSIColors(range, escapeSeq: LogColor.ESCAPE)
            injectLinks()
        }
    }
    
    func applyANSIColors(textStorageRange: NSRange, escapeSeq: String) {
        LogColorKit.applyANSIColorsWithTextStorage(self, textStorageRange: textStorageRange, escapeSeq: escapeSeq)
        // ApplyANSIColors(self, textStorageRange, escapeSeq)
    }
    
    private func injectLinks() {
        
        // \[       匹配[开头的
        // ([\w\+\-]+) 匹配文件名，包含+号-号
        // \.       匹配文件名中的点
        // (\w+)    匹配后缀
        // :        匹配冒号
        // (\d+)    匹配行号
        // \]       匹配]结尾的
        let regularExpr = try! NSRegularExpression(pattern: "\\[(([\\w\\+\\-]+)\\.(\\w+):(\\d+))\\]", options: .CaseInsensitive)
        let matches = regularExpr.matchesInString(self.string, options: .ReportProgress, range: self.editedRange)
        for result in matches where result.numberOfRanges == 5 {
            
            // let fullRange = result.rangeAtIndex(0)
            let linkRange = result.rangeAtIndex(1)
            let fileNameRange = result.rangeAtIndex(2)
            let extensionRange = result.rangeAtIndex(3)
            let lineRange = result.rangeAtIndex(4)
            
            let ocText = self.string.OCString
            let fileName: NSString = "\(ocText.substringWithRange(fileNameRange)).\(ocText.substringWithRange(extensionRange))"
            
            self.addAttribute(StarConsoleLinkFieldName.linkFileName, value: fileName, range: linkRange)
            self.addAttribute(StarConsoleLinkFieldName.linkLine, value: ocText.substringWithRange(lineRange), range: linkRange)
            
            self.addAttribute(NSLinkAttributeName, value: "", range: linkRange)
            self.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0, green: 0, blue: 1, alpha: 1), range: linkRange)
        }
        
    }
    
}




