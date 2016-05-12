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
        
        let attr = self.attributedString().attributesAtIndex(index, effectiveRange: nil)
        
        // 验证标志
        guard attr[StarConsoleLinkFieldName.flag] != nil else {
            star_mouseDown(theEvent)
            return
        }
        
        // 访问[filename.extension:line]的超链接
        if let fileName = attr[StarConsoleLinkFieldName.fileName] as? String,
            let lineNumber = attr[StarConsoleLinkFieldName.line] as? String {
            
            guard let workspacePath = PluginHelper.workspacePath(), let filePath = findFile(workspacePath, fileName) else {
                // 如果是按规则定义的链接，但是没有找到对应的文件，那么此次点击应该使其失效
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
        
        // 访问[filename methodName:]的超链接
        if var fileName = attr[StarConsoleLinkFieldName.fileName] as? String,
            let methodType = attr[StarConsoleLinkFieldName.methodType] as? String,
            let methodName = attr[StarConsoleLinkFieldName.methodName] as? String {
            
            // 暂时只支持查找.m结尾的文件
            fileName.appendContentsOf(".m")
            guard let workspacePath = PluginHelper.workspacePath(), let filePath = findFile(workspacePath, fileName) else {
                return
            }
            if let open = NSApplication.sharedApplication().delegate?.application?(NSApplication.sharedApplication(), openFile: filePath) where open {
                dispatch_get_main_queue().async {
                    if let textView = PluginHelper.editorTextView(inWindow: self.window) {
                        textView.scrollToMethod(methodType, methodName)
                    }
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
                self.lockFocus()
                stop.memory = ObjCBool(true)
            }
        }
    }
    
    private func scrollToMethod(methodType: String, _ methodName: String) {
        
        guard let text = self.string?.OCString else {
            return
        }
        
        
        var passTotalCount = 0
        var passIndex = 0
        
        text.enumerateLinesUsingBlock { (lineText, stop) in
            
            var methodComponents = methodName.componentsSeparatedByString(":")
            
            // 无参函数直接处理
            if methodComponents.count == 1 {
                if lineText.rangeOfString(methodType) != nil
                    && lineText.rangeOfString(methodName) != nil {
                    
                    let lineRange = text.rangeOfString(lineText)
                    self.scrollRangeToVisible(lineRange)
                    self.setSelectedRange(lineRange)
                    stop.memory = ObjCBool(true)
                }
            }
            
            // 有参方法已经完成，但是没有考虑换号，任性，不想做。
            if methodComponents.count > 1 {
                methodComponents.removeLast()
                methodComponents = methodComponents.map { $0 + ":" }
                
                if lineText.rangeOfString(methodType) == nil {
                    // passTotalCount =
                }
                
                if lineText.rangeOfString(methodType) != nil {
                    passTotalCount = methodComponents.count
                    
                    for methodNameElement in methodComponents {
                        if lineText.rangeOfString(methodNameElement) != nil {
                            passIndex += 1
                        }
                    }
                    if (passIndex == passTotalCount) {
                        let lineRange = text.rangeOfString(lineText)
                        self.scrollRangeToVisible(lineRange)
                        self.setSelectedRange(lineRange)
                        stop.memory = ObjCBool(true)
                    }
                }
            }
        }
    }
}

