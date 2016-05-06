//
//  NSTextView-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa


extension NSTextView {
    
    func star_mouseDown(theEvent: NSEvent) {
        
        
        // 当前点击的TextView是否是Xcode的Console
        guard let expectedClass = NSClassFromString("IDEConsoleTextView") where self.isKindOfClass(expectedClass) else {
            star_mouseDown(theEvent)
            return
        }
        
        // 点击区域是否是rich text
        let pos = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        let index = self.characterIndexForInsertionAtPoint(pos)
        guard self.attributedString().length > 1 && index < self.attributedString().length else {
            star_mouseDown(theEvent)
            return
        }
        
        // 当前rich text 是否属于StarConsoleLink
        let attr = self.attributedString().attributesAtIndex(index, effectiveRange: nil)
        guard let fileName = attr[StarConsoleLinkFieldName.linkFileName] as? String,
            let lineNumber = attr[StarConsoleLinkFieldName.linkLine] as? String else {
                star_mouseDown(theEvent)
                return
        }
        
        // 如果是按规则定义的链接，但是没有找到对应的文件，那么此次点击应该使其失效
        guard let workspacePath = PluginHelper.workspacePath(), let filePath = findFile(workspacePath, fileName) else {
            return
        }
        
        // 用编辑器打开文件
        if let open = NSApplication.sharedApplication().delegate?.application?(NSApplication.sharedApplication(), openFile: filePath) where open {
            // 主线程异步调用，防止闪退
            dispatch_get_main_queue().async { () -> Void in
                if let textView = PluginHelper.editorTextView(inWindow: self.window),
                    let line = Int(lineNumber)
                    where line >= 1 {
                    textView.scrollToLine(line)
                }
            }
        }
    }
    
    private func scrollToLine(line: Int) {
        
        guard let text = self.string?.OCString else {
            return
        }
        
        var currentLine = 0
        text.enumerateLinesUsingBlock { (lineText: String, stop: UnsafeMutablePointer<ObjCBool>) in
            currentLine += 1
            if line == currentLine {
                let lineRange = text.rangeOfString(lineText)
                self.scrollRangeToVisible(lineRange)
                self.setSelectedRange(lineRange)
                stop.memory = ObjCBool(true)
            }
        }
    }
}

