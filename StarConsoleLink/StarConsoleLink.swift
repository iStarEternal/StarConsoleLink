//
//  StarConsoleLink.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import AppKit

var sharedPlugin: StarConsoleLink?

class StarConsoleLink: NSObject {
    
    var bundle: NSBundle
    
    lazy var center = NSNotificationCenter.defaultCenter()
    
    
    deinit {
        center.removeObserver(self)
    }
    
    init(bundle: NSBundle) {
        self.bundle = bundle
        super.init()
        center.addObserver(self, selector: #selector(StarConsoleLink.finishLaunchingNotification(_:)), name: NSApplicationDidFinishLaunchingNotification, object: nil)
        center.addObserver(self, selector: #selector(StarConsoleLink.controlGroupDidChangeNotification(_:)), name: "IDEControlGroupDidChangeNotificationName", object: nil)
    }
    
    override static func initialize() {
        swizzleMethods()
    }
    
    
    // MARK: - 通知
    
    func finishLaunchingNotification(notification: NSNotification) {
        center.removeObserver(self, name: NSApplicationDidFinishLaunchingNotification, object: nil)
        createMenuItems()
    }
    
    func controlGroupDidChangeNotification(notification: NSNotification) {
        
        // DVTSourceTextView
        guard let consoleTextView = PluginHelper.consoleTextView(),
            let textStorage = consoleTextView.valueForKey("textStorage") as? NSTextStorage else {
                return
        }
        consoleTextView.linkTextAttributes = [
            NSCursorAttributeName: NSCursor.pointingHandCursor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ]
        textStorage.usedInConsole = ConsoleLinkConfig.enabledLogLinks
    }
    
    
    // MARK: - 改变方法
    
    static func swizzleMethods() {
        do {
            try NSTextStorage.self.jr_swizzleMethod(#selector(NSMutableAttributedString.fixAttributesInRange(_:)), withMethod: #selector(NSTextStorage.star_fixAttributesInRange(_:)))
            try NSTextView.self.jr_swizzleMethod(#selector(NSResponder.mouseDown(_:)), withMethod: #selector(NSTextView.star_mouseDown(_:))
            )
            
        }
        catch let error as NSError {
            Logger.info("Swizzling failed \(error)")
        }
    }
    
    
    // MARK: - 菜单
    
    var pluginsMenuItem: NSMenuItem!
    
    var thisPluginItem: NSMenuItem!
    
    var enabledStarConsoleLinkItem: NSMenuItem!
    
    var enabledLogLinksItem: NSMenuItem!
    
    var enabledLogColorsItem: NSMenuItem!
    
    
    func createMenuItems() {
        
        createPluginsItem()
        
        // 在Plugins上创建Star Console Link 菜单
        createThisPluginMenuItemWithSuperItem(pluginsMenuItem)
        
        createEnabledMenuItemWithSuperItem(thisPluginItem)
        
        createSettingsItemWithSuperItem(thisPluginItem)
        
    }
    
    func createPluginsItem() {
        // 主菜单上创建 Plugins菜单
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
    
    func createThisPluginMenuItemWithSuperItem(superItem: NSMenuItem) {
        thisPluginItem = superItem.submenu?.itemWithTitle("Star Console Link")
        if thisPluginItem == nil {
            thisPluginItem = NSMenuItem()
            thisPluginItem.title = "Star Console Link"
            thisPluginItem.submenu = NSMenu(title: "Star Console Link")
            superItem.submenu?.addItem(NSMenuItem.separatorItem())
            superItem.submenu?.addItem(thisPluginItem)
        }
        
        
    }
    
    func createEnabledMenuItemWithSuperItem(superItem: NSMenuItem) {
        
        // 创建开关
        enabledStarConsoleLinkItem = superItem.submenu?.itemWithTitle("Enabled Star Console Link")
        if enabledStarConsoleLinkItem == nil {
            enabledStarConsoleLinkItem = NSMenuItem()
            enabledStarConsoleLinkItem.title = "Enabled Star Console Link"
            enabledStarConsoleLinkItem.target = self
            enabledStarConsoleLinkItem.action = #selector(StarConsoleLink.handleEnabledStarConsoleLink(_:))
            superItem.submenu?.addItem(enabledStarConsoleLinkItem)
            ConsoleLinkConfig.enabledStarConsoleLink = true
        }
        
        
        // 创建链接开关
        enabledLogLinksItem = superItem.submenu?.itemWithTitle("Enabled Log Links")
        if enabledLogLinksItem == nil {
            enabledLogLinksItem = NSMenuItem()
            enabledLogLinksItem.title = "Enabled Log Links"
            enabledLogLinksItem.target = self
            enabledLogLinksItem.action = #selector(StarConsoleLink.handleEnabledLogLinks(_:))
            
            enabledLogLinksItem.enabled = false
            superItem.submenu?.addItem(enabledLogLinksItem)
            ConsoleLinkConfig.enabledLogLinks = true
        }
        
        // 创建颜色开关
        enabledLogColorsItem = superItem.submenu?.itemWithTitle("Enabled Log Colors")
        if enabledLogColorsItem == nil {
            enabledLogColorsItem = NSMenuItem()
            enabledLogColorsItem.title = "Enabled Log Colors"
            enabledLogColorsItem.target = self
            enabledLogColorsItem.action = #selector(StarConsoleLink.handleEnabledLogColors(_:))
            superItem.submenu?.addItem(enabledLogColorsItem)
            ConsoleLinkConfig.enabledLogColors = true
        }
        
        enabledStarConsoleLinkItem.state = ConsoleLinkConfig.enabledStarConsoleLink ? NSOnState : NSOffState
        enabledLogLinksItem.enabled = false// ConsoleLinkConfig.enabledStarConsoleLink
        enabledLogColorsItem.enabled = ConsoleLinkConfig.enabledStarConsoleLink
        
        
        enabledLogLinksItem.state = ConsoleLinkConfig.enabledLogLinks ? NSOnState : NSOffState
        enabledLogColorsItem.state = ConsoleLinkConfig.enabledLogColors ? NSOnState : NSOffState
        
        
        
    }
    
    func createSettingsItemWithSuperItem(superItem: NSMenuItem) {
        
        
        // 颜色设置：开发中
        var showSettingsItem: NSMenuItem! = superItem.submenu?.itemWithTitle("Log Colors Settings")
        if showSettingsItem == nil {
            showSettingsItem = NSMenuItem()
            showSettingsItem.title = "Log Color Settings"
            showSettingsItem.target = self
            showSettingsItem.action = #selector(StarConsoleLink.handleShowLogColorSettingsItem(_:))
            showSettingsItem.enabled = false
            superItem.submenu?.addItem(NSMenuItem.separatorItem())
            superItem.submenu?.addItem(showSettingsItem)
        }
        
    }
    
    
    func createMenuItemWithTitle() {
        
        
    }
    
    
    func handleEnabledStarConsoleLink(sender: NSMenuItem) {
        
        let consoleTextView = PluginHelper.consoleTextView()
        let textStorage = consoleTextView?.valueForKey("textStorage") as? NSTextStorage
        
        
        if sender.state == NSOnState {
            sender.state = NSOffState
            ConsoleLinkConfig.enabledStarConsoleLink = false
        }
        else {
            sender.state = NSOnState
            ConsoleLinkConfig.enabledStarConsoleLink = true
        }
        
        
        textStorage?.usedInConsole = ConsoleLinkConfig.enabledStarConsoleLink
        enabledLogLinksItem.enabled = ConsoleLinkConfig.enabledStarConsoleLink
        enabledLogColorsItem.enabled = ConsoleLinkConfig.enabledStarConsoleLink
        
    }
    
    func handleEnabledLogLinks(sender: NSMenuItem) {
        
    }
    
    func handleEnabledLogColors(sender: NSMenuItem) {
        
    }
    
    
    
    var settingsWindowController: SettingsWindowController!
    
    func handleShowLogColorSettingsItem(sender: NSMenuItem) {
        settingsWindowController = SettingsWindowController(windowNibName: "SettingsWindowController")
        settingsWindowController.bundle = bundle
        settingsWindowController.showWindow(nil)
    }
    
    
}









