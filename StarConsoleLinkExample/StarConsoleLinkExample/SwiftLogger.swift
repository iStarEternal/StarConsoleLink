//
//  SwiftLogger.swift
//  StarConsoleLinkExample
//
//  Created by 星星 on 16/5/12.
//  Copyright © 2016年 星星. All rights reserved.
//

import Foundation

class SwiftLogger: NSObject {

    func runLog() {
        
        Logger.info("当前在Swift中测试打印")
        Logger.info("测试打印不存在的文件链接：[viewController-abc.swift:25] ")
        Logger.info("测试打印URL链接：[192.168.8.250:8080]")
        Logger.info("测试打印不带方括号的链接：ViewController.swift:19")
        Logger.info("测试打印行号超出的链接：[ViewController.swift:100]")
        
        Logger.warning("------------------ Swift Logger Test ------------------")
        Logger.info("测试颜色打印")
        Logger.debug("测试颜色打印")
        Logger.warning("测试颜色打印")
        Logger.error("测试颜色打印")
        Logger.important("测试颜色打印")
        Logger.success("测试颜色打印")
        Logger.failure("测试颜色打印")
    }
}
