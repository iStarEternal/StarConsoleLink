//
//  ConsoleLinkConfig.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa

class ConsoleLinkConfig: NSObject {
    
    
    private static var __once: () = { () -> Void in
            ConsoleLinkConfigSingleton.instance = ConsoleLinkConfig()
        }()
    
    
    fileprivate struct ConsoleLinkConfigSingleton {
        static var predicate: Int = 0
        static var instance: ConsoleLinkConfig! = nil
    }
    
    static var shared: ConsoleLinkConfig {
        _ = ConsoleLinkConfig.__once
        return ConsoleLinkConfigSingleton.instance
    }
    
    
    static func setConfig(_ config: AnyObject, forKey key: String) {
        UserDefaults.standard.set(config, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func configForKey<T>(_ key: String, defaultValue: T) -> T {
        if let obj = UserDefaults.standard.object(forKey: key) {
            return obj as? T ?? defaultValue
        }
        else {
            return defaultValue
        }
    }
    
    static func configForKey<T>(_ key: String) -> T? {
        if let obj = UserDefaults.standard.object(forKey: key) {
            return obj as? T
        }
        else {
            return nil
        }
    }
    
    
    // MARK: - 是否打开StarConsoleLink
    
    fileprivate static var consoleLinkEnabledKey = "iStar.StarConsoleLink.IsOpenConsoleLink"
    fileprivate var consoleLinkEnabled: Bool?
    static var consoleLinkEnabled: Bool {
        get {
            if shared.consoleLinkEnabled == nil {
                let enabled: Bool? = configForKey(consoleLinkEnabledKey)
                return enabled ?? true
            }
            return shared.consoleLinkEnabled!
        }
        set {
            setConfig(newValue as AnyObject, forKey: consoleLinkEnabledKey)
            shared.consoleLinkEnabled = newValue
        }
    }
    
    
    // MARK: - 中文Unicode
    
    fileprivate static var ChineseUnicodeEnabledKey = "iStar.StarConsoleLink.ChineseUnicodeEnabledKey"
    fileprivate var ChineseUnicodeEnabled: Bool?
    static var ChineseUnicodeEnabled: Bool {
        get {
            if shared.ChineseUnicodeEnabled == nil {
                let enabled: Bool? = configForKey(ChineseUnicodeEnabledKey)
                return enabled ?? true
            }
            return shared.ChineseUnicodeEnabled!
        }
        set {
            setConfig(newValue as AnyObject, forKey: ChineseUnicodeEnabledKey)
            shared.ChineseUnicodeEnabled = newValue
        }
    }
    
    
    fileprivate static let linkColorKeywordKey = "iStar.StarConsoleLink.LinkColorKey"
    fileprivate static let linkColorDefaultValue = 0x0000ff
    fileprivate var linkColor: NSColor?
    static var linkColor: NSColor {
        get {
            if shared.linkColor == nil {
                let intRGB: Int = configForKey(linkColorKeywordKey, defaultValue: linkColorDefaultValue)
                shared.linkColor = NSColor(rgb: intRGB)
            }
            return shared.linkColor!
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: linkColorKeywordKey)
            shared.linkColor = newValue
        }
    }
}

// MARK: - Log config: Base
extension ConsoleLinkConfig {
    
    
    fileprivate static let debugLogKeywordKey = "iStar.StarConsoleLink.DebugLogColorKey"
    fileprivate static let infoLogKeywordKey = "iStar.StarConsoleLink.InfoLogKeywordKey"
    fileprivate static let warningLogKeywordKey = "iStar.StarConsoleLink.WarningLogKeywordKey"
    fileprivate static let errorLogKeywordKey = "iStar.StarConsoleLink.ErrorLogKeywordKey"
    
    fileprivate static let debugLogColorKey = "iStar.StarConsoleLink.DebugLogColorKey"
    fileprivate static let infoLogColorKey = "iStar.StarConsoleLink.InfoLogColorKey"
    fileprivate static let warningLogColorKey = "iStar.StarConsoleLink.WarningLogColorKey"
    fileprivate static let errorLogColorKey = "iStar.StarConsoleLink.ErrorLogColorKey"
    
    
    static var debugLogKeyword: String {
        get {
            return configForKey(debugLogKeywordKey, defaultValue: "[Debug]")
        }
        set {
            setConfig(newValue as AnyObject, forKey: debugLogKeywordKey)
        }
    }
    
    static var infoLogKeyword: String {
        get {
            return configForKey(infoLogKeywordKey, defaultValue: "[Info]")
        }
        set {
            setConfig(newValue as AnyObject, forKey: infoLogKeywordKey)
        }
    }
    
    static var warningLogKeyword: String {
        get {
            return configForKey(warningLogKeywordKey, defaultValue: "[Warning]")
        }
        set {
            setConfig(newValue as AnyObject, forKey: warningLogKeywordKey)
        }
    }
    
    static var errorLogKeyword: String {
        get {
            return configForKey(errorLogKeywordKey, defaultValue: "[Error]")
        }
        set {
            setConfig(newValue as AnyObject, forKey: errorLogKeywordKey)
        }
    }
    
    
    
    
    static var debugLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(debugLogColorKey, defaultValue: 0xFFFF00)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: debugLogColorKey)
        }
    }
    
    static var infoLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(infoLogColorKey, defaultValue: 0x000000)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: infoLogColorKey)
        }
    }
    
    static var warningLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(warningLogColorKey, defaultValue: 0xFFFF00)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: warningLogColorKey)
        }
    }
    
    static var errorLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(errorLogColorKey, defaultValue: 0x00FFFF)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: errorLogColorKey)
        }
    }
}

// MARK: - Log color config: HttpRequest
extension ConsoleLinkConfig {
    
    fileprivate static var successLogColorKey = "iStar.StarConsoleLink.SuccessLogColorKey"
    fileprivate static var failureLogColorKey = "iStar.StarConsoleLink.FailureLogColorKey"
    
    
    static var successLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(successLogColorKey, defaultValue: 0x000000)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: successLogColorKey)
        }
    }
    
    static var failureLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(failureLogColorKey, defaultValue: 0x000000)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb as AnyObject, forKey: failureLogColorKey)
        }
    }
}














