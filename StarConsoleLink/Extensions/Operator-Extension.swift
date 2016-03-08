//
//  Operator-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation


// MARK: - Int 和 CGfloat 加法
public func +(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}

public func +(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs + CGFloat(rhs)
}


// MARK: - Int 和 CGfloat 减法
public func -(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}

public func -(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs - CGFloat(rhs)
}


// MARK: - Int 和 CGfloat 乘法
public func *(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

public func *(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs * CGFloat(rhs)
}


// MARK: - Int 和 CGfloat 除法
public func /(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}

public func /(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}