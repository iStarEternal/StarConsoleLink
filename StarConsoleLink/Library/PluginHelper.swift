//
//  PluginHelper.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation
import AppKit

class PluginHelper: NSObject {
    
    static func runShellCommand(launchPath: String, arguments: [String]) -> String? {
        let pipe = NSPipe()
        let task = NSTask()
        task.launchPath = launchPath
        task.arguments = arguments
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        guard let result = NSString(data: file.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)?.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet()) else {
            return nil
        }
        return result as String
    }
    
    static func getViewByClassName(name: String, inContainer container: NSView) -> NSView? {
        guard let targetClass = NSClassFromString(name) else {
            return nil
        }
        for subview in container.subviews {
            if subview.isKindOfClass(targetClass) {
                return subview
            }
            
            if let view = getViewByClassName(name, inContainer: subview) {
                return view
            }
        }
        
        return nil
    }
}

// MARK: Accessing private API

extension PluginHelper {
    
    static func workspacePath() -> String? {
        
        //        let document = NSApp.orderedDocuments.first
        //        if let workspacePath = document?.fileURL?.URLByDeletingLastPathComponent?.URLByDeletingLastPathComponent?.path {
        //            return workspacePath
        //        }
        
        if let workspacePath = StarFunctions.workspacePath() {
            return workspacePath
        }
        
        guard let anyClass = NSClassFromString("IDEWorkspaceWindowController") as? NSObject.Type,
            let windowControllers = anyClass.valueForKey("workspaceWindowControllers") as? [NSObject],
            let window = NSApp.keyWindow ?? NSApp.windows.first else {
                Logger.info("Failed to establish workspace path")
                return nil
        }
        var workspace: NSObject?
        for controller in windowControllers {
            if controller.valueForKey("window")?.isEqual(window) == true {
                workspace = controller.valueForKey("_workspace") as? NSObject
            }
        }
        
        guard let workspacePath = workspace?.valueForKeyPath("representingFilePath._pathString") as? NSString else {
            Logger.info("Failed to establish workspace path")
            return nil
        }
        
        return workspacePath.stringByDeletingLastPathComponent as String
    }
    
    static func editorTextView(inWindow window: NSWindow? = NSApp.mainWindow) -> NSTextView? {
        guard let window = window,
            let windowController = window.windowController,
            let editor = windowController.valueForKeyPath("editorArea.lastActiveEditorContext.editor"),
            let textView = editor.valueForKey("textView") as? NSTextView else {
                return nil
        }
        
        return textView
    }
    
    static func consoleTextView(inWindow window: NSWindow? = NSApp.mainWindow) -> NSTextView? {
        guard let contentView = window?.contentView,
            let consoleTextView = PluginHelper.getViewByClassName("IDEConsoleTextView", inContainer: contentView) as? NSTextView else {
                return nil
        }
        return consoleTextView
    }
}
