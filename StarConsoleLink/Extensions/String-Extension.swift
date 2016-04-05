//
//  String-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation
import Cocoa

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias Font = UIFont
#else
    import AppKit
    public typealias Font = NSFont
#endif

extension NSString {
    
    var swiftString: String {
        get {
            return self as String
        }
    }
    
    func sizeWithFont(font: Font,maxSize:CGSize) -> CGSize {
        return self.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
}




extension String {
    
    var OCString: NSString {
        get {
            return self as NSString
        }
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
//            return self[Range(start: startIndex, end: endIndex)]
            return self[startIndex ..< endIndex]
        }
    }
    
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    } 
    
    var length:Int{
        get {
            // return self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            return self.characters.count
        }
    }
    
    
    func stringByAppendingPathComponent(pathConmonent: String) -> String {
        
        var first = self
        var last = pathConmonent
        
        if first.hasSuffix("/") {
            var firstArray = first.componentsSeparatedByString("/")
            for var i = firstArray.count - 1; i >= 0; i -= 1 {
                if firstArray[i] == "" {
                    firstArray.removeLast()
                }
                else {
                    break
                }
            }
            first = firstArray.joinWithSeparator("/")
        }
        
        if last.hasPrefix("/") {
            var lastArray = last.componentsSeparatedByString("/")
            for i in lastArray {
                if i == "" {
                    lastArray.removeFirst()
                }
                else {
                    break
                }
            }
            last = lastArray.joinWithSeparator("/")
        }
        
        if !String.isNullOrWhiteSpace(last) {
            last = "/" + last
        }
        
        return first + last
    }
    
    var lastPathComponent: String {
        get {
            return self.OCString.lastPathComponent
        }
    }
    
    func isAllDigit() -> Bool {
        for uni in unicodeScalars{
            if NSCharacterSet.decimalDigitCharacterSet().longCharacterIsMember(uni.value){
                continue
            }
            return false
        }
        return true
    }
    
    var isEmptyOrWhiteSpace: Bool {
        if self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty {
            return true
        }
        return false
    }
    
    func sizeWithFont(font: Font, maxSize:CGSize) -> CGSize {
        return self.OCString.sizeWithFont(font, maxSize: maxSize)
    }
    
    static func isNullOrEmpty(str: String?) -> Bool {
        if str == nil {
            return true
        }
        if str!.isEmpty {
            return true
        }
        return false
    }
    
    static func isNullOrWhiteSpace(str: String?) -> Bool {
        if str == nil {
            return true
        }
        if str!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty {
            return true
        }
        return false
    }
    
}