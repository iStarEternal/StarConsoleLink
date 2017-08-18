//
//  SettingsWindowController.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/2/19.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa
/// 开发中 未完成 以后颜色由Xcode配置，不再由代码配
class SettingsWindowController: NSWindowController {
    
    
    var bundle: NSBundle!
    
    @IBOutlet weak var linkColorWell: NSColorWell!
    
    @IBOutlet weak var debugLogKeywordTextField: NSTextField!
    @IBOutlet weak var infoLogKeywordTextField: NSTextField!
    @IBOutlet weak var warningLogKeywordTextField: NSTextField!
    @IBOutlet weak var errorLogKeywordTextField: NSTextField!
    
    @IBOutlet weak var successLogKeywordTextField: NSTextField!
    @IBOutlet weak var failureLogKeywordTextField: NSTextField!
    
    @IBOutlet weak var assertLogKeywordTextField: NSTextField!
    @IBOutlet weak var fatalLogKeywordTextField: NSTextField!
    
    
    @IBOutlet weak var debugLogColorWell: NSColorWell!
    @IBOutlet weak var infoLogColorWell: NSColorWell!
    @IBOutlet weak var warningLogColorWell: NSColorWell!
    @IBOutlet weak var errorLogColorWell: NSColorWell!
    
    @IBOutlet weak var successLogColorWell: NSColorWell!
    @IBOutlet weak var failureLogColorWell: NSColorWell!
    
    @IBOutlet weak var assertLogColorWell: NSColorWell!
    @IBOutlet weak var fatalLogColorWell: NSColorWell!
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        loadConfig()
    }
    
    func loadConfig() {
        
        linkColorWell.color = ConsoleLinkConfig.linkColor
        
        debugLogKeywordTextField.stringValue = ConsoleLinkConfig.debugLogKeyword
        infoLogKeywordTextField.stringValue = ConsoleLinkConfig.infoLogKeyword
        warningLogKeywordTextField.stringValue = ConsoleLinkConfig.warningLogKeyword
        errorLogKeywordTextField.stringValue = ConsoleLinkConfig.errorLogKeyword
        
        debugLogColorWell.color = ConsoleLinkConfig.debugLogColor
        infoLogColorWell.color = ConsoleLinkConfig.infoLogColor
        warningLogColorWell.color = ConsoleLinkConfig.warningLogColor
        errorLogColorWell.color = ConsoleLinkConfig.errorLogColor
    }
    
    @IBAction func handleKeywordChanged(sender: NSTextField) {
        Logger.info(sender.stringValue)
        
        if sender == debugLogKeywordTextField {
            ConsoleLinkConfig.debugLogKeyword = sender.stringValue
        }
        else if sender == infoLogKeywordTextField {
            ConsoleLinkConfig.infoLogKeyword = sender.stringValue
        }
        else if sender == warningLogKeywordTextField {
            ConsoleLinkConfig.warningLogKeyword = sender.stringValue
        }
        else if sender == errorLogKeywordTextField {
            ConsoleLinkConfig.errorLogKeyword = sender.stringValue
        }
        
    }
    
    
    @IBAction func handleColorChanged(sender: NSColorWell) {
        if sender == linkColorWell {
            ConsoleLinkConfig.linkColor = sender.color
        }
        else if sender == debugLogColorWell {
            ConsoleLinkConfig.debugLogColor = sender.color
        }
        else if sender == infoLogColorWell {
            ConsoleLinkConfig.infoLogColor = sender.color
        }
        else if sender == warningLogColorWell {
            ConsoleLinkConfig.warningLogColor = sender.color
        }
        else if sender == errorLogColorWell {
            ConsoleLinkConfig.errorLogColor = sender.color
        }
    }
    
    
}
