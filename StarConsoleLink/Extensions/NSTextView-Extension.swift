//
//  NSTextView-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa

// [workspacePath : [fileName : filePath]]
var filePathCache = [String : [String : String]]()

extension NSTextView {
    
    func star_mouseDown(theEvent: NSEvent) {
        
        let pos = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        let idx = self.characterIndexForInsertionAtPoint(pos)
        
        guard let expectedClass = NSClassFromString("IDEConsoleTextView")
            where self.isKindOfClass(expectedClass) 
                && self.attributedString().length > 1 
                && idx < self.attributedString().length else {
                    star_mouseDown(theEvent)
                    return
        }
        
        let attr = self.attributedString().attributesAtIndex(idx, effectiveRange: nil)
        
        guard let fileName = attr[StarConsoleLinkFieldName.linkFileName] as? String,
            let lineNumber = attr[StarConsoleLinkFieldName.linkLine] as? String,
            let appDelegate = NSApplication.sharedApplication().delegate else {
                star_mouseDown(theEvent)
                return
        }
        
        guard let workspacePath = PluginHelper.workspacePath(),
            let filePath = findFile(workspacePath, fileName) else {
                // 如果是自己的链接，但是没有找到文件，那么此次点击应该使失效
                return
        }
        if appDelegate.application!(NSApplication.sharedApplication(), openFile: filePath) {
            dispatch_get_main_queue().async { () -> Void in
                if let textView = PluginHelper.editorTextView(inWindow: self.window),
                    let line = Int(lineNumber)
                    where line >= 1 {
                        textView.scrollToLine(line)
                }
            }
        }
    }
    
    func findFile(workspacePath : String, _ fileName : String) -> String? {
        var thisWorkspaceCache = filePathCache[workspacePath] ?? [:]
        if let result = thisWorkspaceCache[fileName] {
            if NSFileManager.defaultManager().fileExistsAtPath(result) {
                return result
            }
        }
        
        var searchPath = workspacePath
        var prevSearchPath : String? = nil
        var searchCount = 0
        while true {
            if let result = findFile(fileName, searchPath, prevSearchPath) where !result.isEmpty {
                thisWorkspaceCache[fileName] = result
                filePathCache[workspacePath] = thisWorkspaceCache
                return result
            }
            
            prevSearchPath = searchPath
            searchPath = searchPath.OCString.stringByDeletingLastPathComponent
            searchCount += 1
            let searchPathCount = searchPath.componentsSeparatedByString("/").count
            if searchPathCount <= 3 || searchCount >= 2 {
                return nil
            }
        }
    }
    
    func findFile(fileName : String, _ searchPath : String, _ prevSearchPath : String?) -> String? {
        let args = (prevSearchPath == nil ?
            ["-L", searchPath, "-name", fileName, "-print", "-quit"] :
            ["-L", searchPath, "-name", prevSearchPath!, "-prune", "-o", "-name", fileName, "-print", "-quit"])
        return PluginHelper.runShellCommand("/usr/bin/find", arguments: args)
    }
    
}

extension NSTextView {
    
    private func scrollToLine(line: Int) {
        
        guard let text = (self.string?.OCString) else {
            return
        }
        var currentLine = 1
        for var index = 0; index < text.length; currentLine += 1 {
            let lineRange = text.lineRangeForRange(NSMakeRange(index, 0))
            index = NSMaxRange(lineRange)
            if currentLine == line {
                self.scrollRangeToVisible(lineRange)
                self.setSelectedRange(lineRange)
                break
            }
        }
    }
}


