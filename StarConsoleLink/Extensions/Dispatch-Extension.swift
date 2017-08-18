//
//  dispatch_queue_t-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/2/17.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
//    func async(_ closure: @escaping ()->()) {
//        self.async(execute: closure)
//    }
//    
//    func sync(_ closure: ()->()) {
//        self.sync(execute: closure)
//    }
//    
//    func delay(_ delay: Double, _ block: @escaping ()->()) {
//        dispatch_delay(delay, self, block)
//    }
}

func dispatch_delay(_ delay: Double, _ block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
        block()
    })
}

func dispatch_delay(_ delay: Double, _ queue: DispatchQueue, _ block: @escaping ()->()) {
    queue.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
        block()
    })
}
