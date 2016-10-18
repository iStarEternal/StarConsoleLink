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
    
    func sizeWithFont(_ font: Font,maxSize:CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
}




extension String {
    
    var OCString: NSString {
        get {
            return self as NSString
        }
    }
    
//    subscript (r: Range<Int>) -> String {
//        get {
//            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
//            let endIndex = <#T##String.CharacterView corresponding to `startIndex`##String.CharacterView#>.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
//            return self[startIndex ..< endIndex]
//            // return self[Range(start: startIndex, end: endIndex)]
//        }
//    }
    
//    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
//        
//        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
//        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
//        if let from = String.Index(from16, within: self),
//            let to = String.Index(to16, within: self) {
//            return from ..< to
//        }
//        return nil
//    }
    
//    func NSRangeFromRange(_ range : Range<String.Index>) -> NSRange {
//        let utf16view = self.utf16
//        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)
//        let to = String.UTF16View.Index(range.upperBound, within: utf16view)
//        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
//    }
//    
    var length:Int{
        get {
            // return self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            return self.characters.count
        }
    }
    
    var lastPathComponent: String {
        get {
            return self.OCString.lastPathComponent
        }
    }
    
    func isAllDigit() -> Bool {
        for uni in unicodeScalars{
            if CharacterSet.decimalDigits.contains(UnicodeScalar(uni.value)!){
                continue
            }
            return false
        }
        return true
    }
    
    var isEmptyOrWhiteSpace: Bool {
        if self.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            return true
        }
        return false
    }
    
    func sizeWithFont(_ font: Font, maxSize:CGSize) -> CGSize {
        return self.OCString.sizeWithFont(font, maxSize: maxSize)
    }
    
    static func isNullOrEmpty(_ str: String?) -> Bool {
        if str == nil {
            return true
        }
        if str!.isEmpty {
            return true
        }
        return false
    }
    
    static func isNullOrWhiteSpace(_ str: String?) -> Bool {
        if str == nil {
            return true
        }
        if str!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            return true
        }
        return false
    }
    
}
