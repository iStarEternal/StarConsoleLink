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
        
        //        center.addObserver(self, selector: #selector(finishLaunchingNotification(_:)), name: NSApplicationDidFinishLaunchingNotification, object: nil)
        //        center.addObserver(self, selector: #selector(controlGroupDidChangeNotification(_:)), name: "IDEControlGroupDidChangeNotificationName", object: nil)
        
        
        center.addObserver(self, selector: "finishLaunchingNotification:", name: NSApplicationDidFinishLaunchingNotification, object: nil)
        center.addObserver(self, selector: "controlGroupDidChangeNotification:", name: "IDEControlGroupDidChangeNotificationName", object: nil)
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
        textStorage.usedInConsole = ConsoleLinkConfig.enabledConsoleLink
    }
    
    
    // MARK: - 改变方法
    
    static func swizzleMethods() {
        do {
            
            // try NSTextStorage.self.jr_swizzleMethod(#selector(NSTextStorage.fixAttributesInRange(_:)), withMethod: #selector(NSTextStorage.star_fixAttributesInRange(_:)))
            // try NSTextView.self.jr_swizzleMethod(#selector(NSTextView.mouseDown(_:)), withMethod: #selector(NSTextView.star_mouseDown(_:)))
            
            try NSTextStorage.self.jr_swizzleMethod("fixAttributesInRange:", withMethod: "star_fixAttributesInRange:")
            try NSTextView.self.jr_swizzleMethod("mouseDown:", withMethod: "star_mouseDown:")
        }
        catch let error as NSError {
            Logger.info("Swizzling failed \(error)")
        }
    }
    
    
    // MARK: - 创建菜单
    
    func createMenuItems() {
        
        // 主菜单上创建 Plugins菜单
        var pluginsMenuItem: NSMenuItem! = NSApp.mainMenu?.itemWithTitle("Plugins")
        if pluginsMenuItem == nil {
            pluginsMenuItem = NSMenuItem()
            pluginsMenuItem.title = "Plugins"
            pluginsMenuItem.submenu = NSMenu(title: "Plugins")
            if let windowIndex = NSApp.mainMenu?.indexOfItemWithTitle("Window") {
                NSApp.mainMenu?.insertItem(pluginsMenuItem, atIndex: windowIndex)
            }
        }
        
        // 在Plugins上创建Star Console Link 菜单
        var starConsoleLinkItem: NSMenuItem! = pluginsMenuItem.submenu?.itemWithTitle("Star Console Link")
        if starConsoleLinkItem == nil {
            starConsoleLinkItem = NSMenuItem()
            starConsoleLinkItem.title = "Star Console Link"
            starConsoleLinkItem.submenu = NSMenu(title: "Star Console Link")
            pluginsMenuItem.submenu?.addItem(NSMenuItem.separatorItem())
            pluginsMenuItem.submenu?.addItem(starConsoleLinkItem)
        }
        
        // 在Star Console Link 菜单上创建开关
        var enabledConsoleLinkItem: NSMenuItem! = starConsoleLinkItem.submenu?.itemWithTitle("Enabled")
        if enabledConsoleLinkItem == nil {
            enabledConsoleLinkItem = NSMenuItem()
            enabledConsoleLinkItem.title = "Enabled"
            enabledConsoleLinkItem.target = self
            // enabledConsoleLinkItem.action = #selector(handleEnabledConsoleLink(_:))
            enabledConsoleLinkItem.action = "handleEnabledConsoleLink:"
            starConsoleLinkItem.submenu?.addItem(enabledConsoleLinkItem)
            ConsoleLinkConfig.enabledConsoleLink = true
        }
        
        enabledConsoleLinkItem.state = ConsoleLinkConfig.enabledConsoleLink ? NSOnState : NSOffState
        
        
        
        // 在Star Console Link 菜单上创建开关
        var showSettingsItem: NSMenuItem! = starConsoleLinkItem.submenu?.itemWithTitle("Settings")
        if showSettingsItem == nil {
            showSettingsItem = NSMenuItem()
            showSettingsItem.title = "Settings"
            showSettingsItem.target = self
            // showSettingsItem.action = #selector(handleShowSettingsItem(_:))
            showSettingsItem.action = "handleShowSettingsItem:"
            starConsoleLinkItem.submenu?.addItem(showSettingsItem)
        }
        
    }
    
    func handleEnabledConsoleLink(item: NSMenuItem) {
        
        let consoleTextView = PluginHelper.consoleTextView()
        let textStorage = consoleTextView?.valueForKey("textStorage") as? NSTextStorage
        if item.state == NSOnState {
            ConsoleLinkConfig.enabledConsoleLink = false
            item.state = NSOffState
            textStorage?.usedInConsole = false
        }
        else {
            ConsoleLinkConfig.enabledConsoleLink = true
            item.state = NSOnState
            textStorage?.usedInConsole = true
        }
    }
    
    var settingsWindowController: SettingsWindowController!
    
    func handleShowSettingsItem(item: NSMenuItem) {
        settingsWindowController = SettingsWindowController(windowNibName: "SettingsWindowController")
        settingsWindowController.bundle = bundle
        settingsWindowController.showWindow(nil)
    }
    
    
}









