//
//  StarConsoleLink.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import AppKit

var sharedPlugin: StarConsoleLink?

class StarConsoleLink: NSObject, NSTextStorageDelegate {
    
    
    // MARK: - Swizzle Methods
    
    override static func initialize() {
        self.swizzleMethods()
    }
    
    static func swizzleMethods() {
        do {
            
            #if swift(>=2.2)
                try NSTextStorage.self.jr_swizzleMethod(#selector(NSTextStorage.fixAttributesInRange(_:)), withMethod: #selector(NSTextStorage.star_fixAttributesInRange(_:)))
                try NSTextView.self.jr_swizzleMethod(#selector(NSTextView.mouseDown(_:)), withMethod: #selector(NSTextView.star_mouseDown(_:)))
            #else
                try NSTextStorage.self.jr_swizzleMethod("fixAttributesInRange:", withMethod: "star_fixAttributesInRange:")
                try NSTextView.self.jr_swizzleMethod("mouseDown:", withMethod: "star_mouseDown:")
            #endif
        }
        catch let error as NSError {
            Logger.info("Swizzling failure: \(error)")
        }
    }
    
    
    
    
    var bundle: NSBundle
    
    lazy var notificationCenter = NSNotificationCenter.defaultCenter()
    
    
    
    // MARK: - Init
    
    init(bundle: NSBundle) {
        self.bundle = bundle
        super.init()
        
        #if swift(>=2.2)
            notificationCenter.addObserver(self,
                                           selector: #selector(StarConsoleLink.handleFinishLaunchingNotification(_:)),
                                           name: NSApplicationDidFinishLaunchingNotification,
                                           object: nil)
            
            //            center.addObserver(self,
            //                               selector: #selector(StarConsoleLink.handleControlGroupDidChangeNotification(_:)),
            //                               name: "IDEControlGroupDidChangeNotificationName",
            //                               object: nil)
            
            notificationCenter.addObserver(self,
                                           selector: #selector(StarConsoleLink.handleTextStorageDidChange(_:)),
                                           name: NSTextDidChangeNotification,
                                           object: nil)
        #else
            center.addObserver(self, selector: "handleFinishLaunchingNotification:", name: NSApplicationDidFinishLaunchingNotification, object: nil)
            // center.addObserver(self, selector: "handleControlGroupDidChangeNotification:", name: "IDEControlGroupDidChangeNotificationName", object: nil)
            center.addObserver(self, selector: "handleTextStorageDidChange:", name: NSTextDidChangeNotification, object: nil)
        #endif
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    
    // MARK: - 通知
    
    func handleFinishLaunchingNotification(notification: NSNotification) {
        notificationCenter.removeObserver(self, name: NSApplicationDidFinishLaunchingNotification, object: nil)
        createMenuItems()
    }
    
    func handleControlGroupDidChangeNotification(notification: NSNotification) {
        
    }
    
    func handleTextStorageDidChange(notification: NSNotification) {
        
        guard let targetClass = NSClassFromString("IDEConsoleTextView") else {
            return
        }
        
        guard let obj = notification.object where obj.isKindOfClass(targetClass) else {
            return
        }
        guard let consoleTextView = obj as? NSTextView, let textStorage = consoleTextView.textStorage else {
            return
        }
        
        consoleTextView.linkTextAttributes = [
            NSCursorAttributeName: NSCursor.pointingHandCursor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ]
        
        textStorage.usedInConsole = true
        textStorage.delegate = self;
        Logger.warning("Used In XcodeConsole \(textStorage.usedInConsole)")
    }
    
    
    
    // MARK: - 替换Unicode
    
    func textStorage(textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        if !ConsoleLinkConfig.ChineseUnicodeEnabled {
            return;
        }
        
        if editedMask == .EditedAttributes || editedRange.length <= 0 {
            return;
        }
        
        let strong = textStorage.string.OCString
        
        let contentsStr = editedRange.location == 0 ? strong.substringWithRange(strong.rangeOfComposedCharacterSequencesForRange(editedRange)) : strong
        
        if (contentsStr.length < (editedRange.location + editedRange.length)) {
            return;
        }
        
        let editRangeStr = contentsStr.substringWithRange(contentsStr.rangeOfComposedCharacterSequencesForRange(editedRange))
        
        textStorage.beginEditing()
        textStorage.replaceCharactersInRange(editedRange, withString: self.stringByReplaceUnicode(editRangeStr))
        textStorage.endEditing()
    }
    
    private func stringByReplaceUnicode(string: String) -> String {
        
        let convertedString = string.OCString.mutableCopy() as! NSMutableString
        convertedString .replaceOccurrencesOfString("\\U", withString: "\\u", options: NSStringCompareOptions(), range: NSMakeRange(0, convertedString.length))
        CFStringTransform(convertedString, nil, "Any-Hex/Java", true)
        return convertedString.swiftString
    }
    
    
    
    // MARK: - 菜单
    
    var pluginsMenuItem: NSMenuItem!
    var starConsoleLinkItem: NSMenuItem!
    var consoleLinkEnabledItem: NSMenuItem!
    var ChineseUnicodeEnabledItem: NSMenuItem!
    var showSettingsItem: NSMenuItem!
    
    
    func createMenuItems() {
        createMainMenuItem();
        createStarConsoleLinkItem()
        
        createConsoleLinkEnabledItem()
        createChineseUnicodeEnabledItem()
        createSettingsItem()
    }
    
    func createMainMenuItem() {
        
        // 主菜单上添加Plugins菜单
        pluginsMenuItem = NSApp.mainMenu?.itemWithTitle("Plugins")
        if pluginsMenuItem == nil {
            pluginsMenuItem = NSMenuItem()
            pluginsMenuItem.title = "Plugins"
            pluginsMenuItem.submenu = NSMenu(title: "Plugins")
            if let windowIndex = NSApp.mainMenu?.indexOfItemWithTitle("Window") {
                NSApp.mainMenu?.insertItem(pluginsMenuItem, atIndex: windowIndex)
            }
        }
    }
    
    func createStarConsoleLinkItem() {
        
        // 在Plugins上添加Star Console Link
        starConsoleLinkItem = pluginsMenuItem.submenu?.itemWithTitle("Star Console Link")
        if starConsoleLinkItem == nil {
            starConsoleLinkItem = NSMenuItem()
            starConsoleLinkItem.title = "Star Console Link"
            starConsoleLinkItem.submenu = NSMenu(title: "Star Console Link")
            pluginsMenuItem.submenu?.addItem(NSMenuItem.separatorItem())
            pluginsMenuItem.submenu?.addItem(starConsoleLinkItem)
        }
    }
    
    func createConsoleLinkEnabledItem() {
        
        // 在Star Console Link 菜单上添加Enabled
        consoleLinkEnabledItem = starConsoleLinkItem.submenu?.itemWithTitle("😄Enabled")
        if consoleLinkEnabledItem == nil {
            consoleLinkEnabledItem = NSMenuItem()
            consoleLinkEnabledItem.title = "😄Enabled"
            consoleLinkEnabledItem.target = self
            #if swift(>=2.2)
                consoleLinkEnabledItem.action = #selector(handleConsoleLinkEnabled(_:))
            #else
                consoleLinkEnabledItem.action = "handleConsoleLinkEnabled:"
            #endif
            starConsoleLinkItem.submenu?.addItem(consoleLinkEnabledItem)
        }
        consoleLinkEnabledItem.state = ConsoleLinkConfig.consoleLinkEnabled ? NSOnState : NSOffState
        
        
    }
    
    func createChineseUnicodeEnabledItem() {
        
        // 在StarConsoleLink 菜单上添加Chinese Unicode Enabled
        ChineseUnicodeEnabledItem = starConsoleLinkItem.submenu?.itemWithTitle("🀄︎Chinese Unicode Enabled")
        if ChineseUnicodeEnabledItem == nil {
            ChineseUnicodeEnabledItem = NSMenuItem()
            ChineseUnicodeEnabledItem.title = "🀄︎Chinese Unicode Enabled"
            ChineseUnicodeEnabledItem.target = self
            #if swift(>=2.2)
                ChineseUnicodeEnabledItem.action = #selector(handleChineseUnicodeEnabled(_:))
            #else
                enabledConsoleChineseUnicodeItem.action = "handleChineseUnicodeEnabled:"
            #endif
            starConsoleLinkItem.submenu?.addItem(ChineseUnicodeEnabledItem)
        }
        ChineseUnicodeEnabledItem.state = ConsoleLinkConfig.ChineseUnicodeEnabled ? NSOnState : NSOffState
        
    }
    
    func createSettingsItem() {
        
        
        
        // 在Star Console Link 菜单添加 Settings
        var showSettingsItem: NSMenuItem! = starConsoleLinkItem.submenu?.itemWithTitle("💭Settings")
        if showSettingsItem == nil {
            showSettingsItem = NSMenuItem()
            showSettingsItem.title = "💭Settings"
            showSettingsItem.target = self
            #if swift(>=2.2)
                showSettingsItem.action = #selector(handleShowSettingsItem(_:))
            #else
                showSettingsItem.action = "handleShowSettingsItem:"
            #endif
            starConsoleLinkItem.submenu?.addItem(showSettingsItem)
        }
    }
    
    
    
    
    func handleConsoleLinkEnabled(item: NSMenuItem) {
        
        if item.state == NSOnState {
            ConsoleLinkConfig.consoleLinkEnabled = false
            item.state = NSOffState
        }
        else {
            ConsoleLinkConfig.consoleLinkEnabled = true
            item.state = NSOnState
        }
    }
    
    func handleChineseUnicodeEnabled(item: NSMenuItem) {
        
        if item.state == NSOnState {
            ConsoleLinkConfig.ChineseUnicodeEnabled = false
            item.state = NSOffState
        }
        else {
            ConsoleLinkConfig.ChineseUnicodeEnabled = true
            item.state = NSOnState
        }
    }
    
    
    // MARK: - Setting Window
    
    var settingsWindowController: SettingsWindowController!
    
    func handleShowSettingsItem(item: NSMenuItem) {
        settingsWindowController = SettingsWindowController(windowNibName: "SettingsWindowController")
        settingsWindowController.bundle = bundle
        settingsWindowController.showWindow(nil)
    }
    
    
}









