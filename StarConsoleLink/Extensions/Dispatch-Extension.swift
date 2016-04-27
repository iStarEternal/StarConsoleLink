//
//  dispatch_queue_t-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/2/17.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation

extension dispatch_queue_t {
    
    func async(closure: dispatch_block_t) {
        dispatch_async(self, closure)
    }
    
    func sync(closure: dispatch_block_t) {
        dispatch_sync(self, closure)
    }
    
    func delay(delay: Double, _ block: dispatch_block_t) {
        dispatch_delay(delay, self, block)
    }
}

func dispatch_delay(delay: Double, _ block: dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
        block()
    })
}

func dispatch_delay(delay: Double, _ queue: dispatch_queue_t, _ block: dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(delay * Double(NSEC_PER_SEC))), queue, { () -> Void in
        block()
    })
}
