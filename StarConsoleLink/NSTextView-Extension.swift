//
//  NSTextView-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Cocoa


extension NSTextView {
    
    
    func star_mouseDown(_ theEvent: NSEvent) {
        
        
        // 当前点击的TextView是否是Xcode的Console
        guard let expectedClass = NSClassFromString("IDEConsoleTextView") , self.isKind(of: expectedClass) else {
            star_mouseDown(theEvent)
            return
        }
        
        // 点击区域是否是rich text
        let pos = self.convert(theEvent.locationInWindow, from:nil)
        let index = self.characterIndexForInsertion(at: pos)
        guard self.attributedString().length > 1 && index < self.attributedString().length else {
            star_mouseDown(theEvent)
            return
        }
        
        let attr = self.attributedString().attributes(at: index, effectiveRange: nil)
        
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
            if let open = NSApplication.shared().delegate?.application?(NSApplication.shared(), openFile: filePath) , open {
                // 主线程异步调用，防止闪退
                DispatchQueue.main.async { () -> Void in
                    if let textView = PluginHelper.editorTextView(inWindow: self.window),
                        let line = Int(lineNumber)
                        , line >= 1 {
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
            fileName.append(".m")
            guard let workspacePath = PluginHelper.workspacePath(), let filePath = findFile(workspacePath, fileName) else {
                return
            }
            if let open = NSApplication.shared().delegate?.application?(NSApplication.shared(), openFile: filePath) , open {
                
                DispatchQueue.main.async {
                    if let textView = PluginHelper.editorTextView(inWindow: self.window) {
                        textView.scrollToMethod(methodType, methodName)
                    }
                }
            }
        }
    }
    
    fileprivate func scrollToLine(_ line: Int) {
        
        guard let text = self.string?.OCString else {
            return
        }
        
        var currentLine:Int = 0
        text.enumerateLines { (lineText: String, stop: UnsafeMutablePointer<ObjCBool>) in
            currentLine += 1
            if line == currentLine {
                let lineRange = text.range(of: lineText)
                if lineRange.location != NSNotFound {
                    self.scrollRangeToVisible(lineRange)
                    self.setSelectedRange(lineRange)
                }
                stop.pointee = ObjCBool(true)
            }
        }
    }
    
    fileprivate func scrollToMethod(_ methodType: String, _ methodName: String) {
        
        guard let text = self.string?.OCString else {
            return
        }
        
        var passTotalCount = 0
        var passIndex = 0
        
        text.enumerateLines { (lineText, stop) in
            
            var methodComponents = methodName.components(separatedBy: ":")
            
            // 无参函数直接处理
            if methodComponents.count == 1 {
                if lineText.range(of: methodType) != nil
                    && lineText.range(of: methodName) != nil {
                    
                    let lineRange = text.range(of: lineText)
                    if lineRange.location != NSNotFound {
                        self.scrollRangeToVisible(lineRange)
                        self.setSelectedRange(lineRange)
                        stop.pointee = ObjCBool(true)
                    }
                }
            }
            
            // 有参方法已经完成，但是没有考虑换行的情况，任性，不想做，想让我做给钱。。。。
            if methodComponents.count > 1 {
                methodComponents.removeLast()
                methodComponents = methodComponents.map { $0 + ":" }
                
                if lineText.range(of: methodType) == nil {
                }
                
                if lineText.range(of: methodType) != nil {
                    passTotalCount = methodComponents.count
                    
                    for methodElement in methodComponents {
                        if lineText.range(of: methodElement) != nil {
                            passIndex += 1
                        }
                    }
                    if (passIndex == passTotalCount) {
                        let lineRange = text.range(of: lineText)
                        if lineRange.location != NSNotFound {
                            self.scrollRangeToVisible(lineRange)
                            self.setSelectedRange(lineRange)
                            stop.pointee = ObjCBool(true)
                        }
                    }
                }
            }
        }
    }
    
    
    func star_insertNewline(_ arg1: AnyObject) {
        self.star_checkTextView()
        self.star_insertNewline(arg1)
    }
    
    func star_clearConsoleItems() {
        self.star_checkTextView()
        self.star_clearConsoleItems()
    }
    
    func star_shouldChangeTextInRanges(_ ranges: AnyObject, replacementStrings strings: AnyObject) -> Bool {
        self.star_checkTextView()
        return self.star_shouldChangeTextInRanges(ranges, replacementStrings: strings)
    }
    
    
    func star_checkTextView() {
        
        guard let expectedClass = NSClassFromString("IDEConsoleTextView")
            , self.isKind(of: expectedClass) else {
                return
        }
        guard let textStorage = self.textStorage else {
            return
        }
        if let startLocationOfLastLine = self.value(forKeyPath: "_startLocationOfLastLine") as? Int
            , textStorage.length < startLocationOfLastLine {
            self.setValue(textStorage.length, forKeyPath: "_startLocationOfLastLine")
        }
        
        if let lastRemovableTextLocation = self.value(forKeyPath: "_lastRemovableTextLocation") as? Int
            , textStorage.length < lastRemovableTextLocation {
            self.setValue(textStorage.length, forKeyPath: "_lastRemovableTextLocation")
        }
    }
}

