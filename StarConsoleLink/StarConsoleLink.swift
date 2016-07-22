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
    
    
    
    // MARK: - Static
    
    override static func initialize() {
        self.swizzleConsoleTextViewMethods()
    }
    
    static func swizzleConsoleTextViewMethods() {
        do {
            
            // 防止2.2警告，并不用做>=2.1兼容，采用NSSelectorFromString
            try NSTextStorage.self.jr_swizzleMethod(NSSelectorFromString("fixAttributesInRange:"),
                                                    withMethod: NSSelectorFromString("star_fixAttributesInRange:"))
            
            guard let targetClass = NSClassFromString("IDEConsoleTextView") as? NSObject.Type else {
                return
            }
            // StarFunctions.printMothList(targetClass)
            // let i = StarFunctions.getAllProperties(targetClass)
            try targetClass.self.jr_swizzleMethod(NSSelectorFromString("mouseDown:"),
                                                  withMethod: NSSelectorFromString("star_mouseDown:"))
            try targetClass.self.jr_swizzleMethod(NSSelectorFromString("star_insertNewline:"),
                                                  withMethod: NSSelectorFromString("insertNewline:"))
            try targetClass.self.jr_swizzleMethod(NSSelectorFromString("clearConsoleItems"),
                                                  withMethod: NSSelectorFromString("star_clearConsoleItems"))
            try targetClass.self.jr_swizzleMethod(NSSelectorFromString("shouldChangeTextInRanges:replacementStrings:"),
                                                  withMethod: NSSelectorFromString("star_shouldChangeTextInRanges:replacementStrings:"))
        }
        catch let e as NSError {
            Logger.info("Swizzling failure: \(e)")
        }
    }
    
    
    
    // MARK: Proptices
    
    var bundle: NSBundle
    
    lazy var notificationCenter = NSNotificationCenter.defaultCenter()
    
    
    
    // MARK: - Init
    
    init(bundle: NSBundle) {
        self.bundle = bundle
        super.init()
        addStarConsoleLinkObserver()
    }
    
    func addStarConsoleLinkObserver() {
        notificationCenter.addObserver(self,
                                       selector: NSSelectorFromString("handleFinishLaunchingNotification:"),
                                       name: NSApplicationDidFinishLaunchingNotification,
                                       object: nil)
        // notificationCenter.addObserver(self, selector: "handleControlGroupDidChangeNotification:", name: "IDEControlGroupDidChangeNotificationName", object: nil)
        notificationCenter.addObserver(self,
                                       selector: NSSelectorFromString("handleTextStorageDidChange:"),
                                       name: NSTextDidChangeNotification,
                                       object: nil)
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
    
    
    
    // MARK: - TextStrogage Delegate - 替换Unicode
    
    func textStorage(textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        guard ConsoleLinkConfig.ChineseUnicodeEnabled else {
            return
        }
        if editedMask == .EditedAttributes || editedRange.length <= 0  {
            return
        }
        
        guard let string = textStorage.valueForKeyPath("_contents.mutableString") as? NSString else {
            return
        }
        
        let contentsStr = editedRange.location == 0 ? string.substringWithRange(string.rangeOfComposedCharacterSequencesForRange(editedRange)) : string
        
        if contentsStr.length < (editedRange.location + editedRange.length) {
            return;
        }
        
        let editRangeStr = contentsStr.substringWithRange(contentsStr.rangeOfComposedCharacterSequencesForRange(editedRange))
        
        textStorage.beginEditing()
        textStorage.replaceCharactersInRange(editedRange, withString: self.stringByReplaceUnicode(editRangeStr))
        textStorage.endEditing()
    }
    
    private func stringByReplaceUnicode(string: String) -> String {
        
        let convertedString = string.OCString.mutableCopy() as! NSMutableString
        convertedString.replaceOccurrencesOfString("\\U", withString: "\\u", options: NSStringCompareOptions(), range: NSMakeRange(0, convertedString.length))
        CFStringTransform(convertedString, nil, "Any-Hex/Java", true)
        
        // 再找到解决方案之前，先用空格填充补全的方式来解决系统的索引越界问题
        let tran = string.OCString.length - convertedString.length;
        if tran > 0 {
            for i in (0..<tran) {
                if i == (tran - 1) {
                    convertedString.appendString("\n");
                }
                else {
                    convertedString.appendString(" ");
                }
            }
        }
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
            consoleLinkEnabledItem.action = NSSelectorFromString("handleConsoleLinkEnabled:")
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
            ChineseUnicodeEnabledItem.action = NSSelectorFromString("handleChineseUnicodeEnabled:")
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
            showSettingsItem.action = NSSelectorFromString("handleShowSettingsItem:")
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









