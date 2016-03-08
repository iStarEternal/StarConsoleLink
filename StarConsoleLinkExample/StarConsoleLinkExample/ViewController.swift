//
//  ViewController.swift
//  StarConsoleLinkExample
//
//  Created by 黄耀红 on 16/2/17.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.info("当前在Swift中测试打印") 
        Logger.info("测试打印不存在的文件链接：[viewController-abc.swift:25] ")
        Logger.info("测试打印URL链接：[192.168.8.250:8080]")
        Logger.info("测试打印不带方括号的链接：ViewController.swift:19")
        Logger.info("测试打印行号超出的链接：[ViewController.swift:100]")
        
        OCLogger().runLog()
        
        Logger.info("测试颜色打印")
        Logger.debug("测试颜色打印") 
        Logger.warning("测试颜色打印") 
        Logger.error("测试颜色打印") 
        Logger.important("测试颜色打印") 
        Logger.success("测试颜色打印") 
        Logger.failure("测试颜色打印")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

