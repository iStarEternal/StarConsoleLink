//
//  ConsoleLinkConfig.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa

class ConsoleLinkConfig: NSObject {
    
    
    private struct ConsoleLinkConfigSingleton {
        static var predicate: dispatch_once_t = 0
        static var instance: ConsoleLinkConfig! = nil
    }
    
    static var shared: ConsoleLinkConfig {
        dispatch_once(&ConsoleLinkConfigSingleton.predicate) { () -> Void in
            ConsoleLinkConfigSingleton.instance = ConsoleLinkConfig()
        }
        return ConsoleLinkConfigSingleton.instance
    }
    
    
    static func setConfig(config: AnyObject, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setObject(config, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func configForKey<T>(key: String, defaultValue: T) -> T {
        if let obj = NSUserDefaults.standardUserDefaults().objectForKey(key) {
            return obj as? T ?? defaultValue
        }
        else {
            return defaultValue
        }
    }
    
    static func configForKey<T>(key: String) -> T? {
        if let obj = NSUserDefaults.standardUserDefaults().objectForKey(key) {
            return obj as? T
        }
        else {
            return nil
        }
    }
    
}

// MARK: - Enabled
extension ConsoleLinkConfig {
    
    private static let enabledStarConsoleLinkKey = "iStar.StarConsoleLink.EnabledStarConsoleLink"
    private static let enabledLogLinksKey = "iStar.StarConsoleLink.EnabledLogLinks"
    private static let enabledLogColorsKey = "iStar.StarConsoleLink.EnabledLogColors"
    
    /// 允许插件启用
    static var enabledStarConsoleLink: Bool {
        get {
            let enabled: Bool? = configForKey(enabledStarConsoleLinkKey)
            return enabled ?? false
        }
        set {
            setConfig(newValue, forKey: enabledStarConsoleLinkKey)
        }
    }
    
    /// 是否允许日志超链接
    static var enabledLogLinks: Bool {
        get {
            let enabled: Bool? = configForKey(enabledLogLinksKey)
            return enabled ?? false
        }
        set {
            setConfig(newValue, forKey: enabledLogLinksKey)
        }
    }
    
    /// 是否允许日志颜色
    static var enabledLogColors: Bool {
        get {
            let enabled: Bool? = configForKey(enabledLogColorsKey)
            return enabled ?? false
        }
        set {
            setConfig(newValue, forKey: enabledLogColorsKey)
        }
    }
    
}

// MARK: - Log config: Base
extension ConsoleLinkConfig {
    
    
    private static let debugLogKeywordKey = "iStar.StarConsoleLink.DebugLogColorKey"
    private static let infoLogKeywordKey = "iStar.StarConsoleLink.InfoLogKeywordKey"
    private static let warningLogKeywordKey = "iStar.StarConsoleLink.WarningLogKeywordKey"
    private static let errorLogKeywordKey = "iStar.StarConsoleLink.ErrorLogKeywordKey"
    
    private static let debugLogColorKey = "iStar.StarConsoleLink.DebugLogColorKey"
    private static let infoLogColorKey = "iStar.StarConsoleLink.InfoLogColorKey"
    private static let warningLogColorKey = "iStar.StarConsoleLink.WarningLogColorKey"
    private static let errorLogColorKey = "iStar.StarConsoleLink.ErrorLogColorKey"
    
    
    static var debugLogKeyword: String {
        get {
            return configForKey(debugLogKeywordKey, defaultValue: "[Debug]")
        }
        set {
            setConfig(newValue, forKey: debugLogKeywordKey)
        }
    }
    
    static var infoLogKeyword: String {
        get {
            return configForKey(infoLogKeywordKey, defaultValue: "[Info]")
        }
        set {
            setConfig(newValue, forKey: infoLogKeywordKey)
        }
    }
    
    static var warningLogKeyword: String {
        get {
            return configForKey(warningLogKeywordKey, defaultValue: "[Warning]")
        }
        set {
            setConfig(newValue, forKey: warningLogKeywordKey)
        }
    }
    
    static var errorLogKeyword: String {
        get {
            return configForKey(errorLogKeywordKey, defaultValue: "[Error]")
        }
        set {
            setConfig(newValue, forKey: errorLogKeywordKey)
        }
    }
    
    
    
    
    static var debugLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(debugLogColorKey, defaultValue: 0xFFFF00)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb, forKey: debugLogColorKey)
        }
    }
    
    static var infoLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(infoLogColorKey, defaultValue: 0x000000)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb, forKey: infoLogColorKey)
        }
    }
    
    static var warningLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(warningLogColorKey, defaultValue: 0xFFFF00)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb, forKey: warningLogColorKey)
        }
    }
    
    static var errorLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(errorLogColorKey, defaultValue: 0x00FFFF)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb, forKey: errorLogColorKey)
        }
    }
}

// MARK: - Log color config: HttpRequest
extension ConsoleLinkConfig {
    
    private static var successLogColorKey = "iStar.StarConsoleLink.SuccessLogColorKey"
    private static var failureLogColorKey = "iStar.StarConsoleLink.FailureLogColorKey"
    
    
    static var successLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(successLogColorKey, defaultValue: 0x000000)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb, forKey: successLogColorKey)
        }
    }
    
    static var failureLogColor: NSColor {
        get {
            let intRGB: Int = configForKey(failureLogColorKey, defaultValue: 0x000000)
            return NSColor(rgb: intRGB)
        }
        set {
            setConfig(newValue.rgb, forKey: failureLogColorKey)
        }
    }
}














