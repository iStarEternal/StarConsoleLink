//
//  UIColor-Extension.swift
//  AviationLogin
//
//  Created by 星星 on 15/7/28.
//  Copyright (c) 2015年 chinaaviationconsulting. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias Color = UIColor
#else
    import AppKit
    public typealias Color = NSColor
#endif


extension Color {
    
    convenience init(r:Int, g:Int, b:Int, a:CGFloat) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
    convenience init(rgb:Int) {
        let red = Double((rgb >> 16) & 0xff) / 255.0
        let green = Double((rgb >> 8) & 0xff) / 255.0
        let blue = Double(rgb & 0xff) / 255.0
        self.init(red:CGFloat(red), green:CGFloat(green), blue:CGFloat(blue), alpha:CGFloat(1))
    }
    
    /// alpha range: 0.1 - 1.0
    convenience init(rgb: Int, alpha: CGFloat) {
        let red = Double((rgb >> 16) & 0xff) / 255.0
        let green = Double((rgb >> 8) & 0xff) / 255.0
        let blue = Double(rgb & 0xff) / 255.0
        self.init(red:CGFloat(red), green:CGFloat(green), blue:CGFloat(blue), alpha:alpha)
    }
    
    //    convenience init(rgba:Int) {
    //        let red = Double((rgba >> 32) & 0xff) / 255.0
    //        let green = Double((rgba >> 16) & 0xff) / 255.0
    //        let blue = Double((rgba >> 8) & 0xff) / 255.0
    //        let alpha = Double(rgba & 0xff) / 255.0
    //        self.init(red:CGFloat(red), green:CGFloat(green), blue:CGFloat(blue), alpha:CGFloat(alpha))
    //    }
    
    
    static func rgb(rgb: Int) -> Color {
        return Color(rgb: rgb)
    }
    
    var rgb: Int {
        
        #if os(iOS) || os(tvOS)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let intRed = Int(red * 255.0)
            let intGreen = Int(red * 255.0)
            let intBlue = Int(red * 255.0)
            return (intRed << 16) + (intGreen << 8) + intBlue
        #else
            let red = Int(self.redComponent * 255.0)
            let green = Int(self.greenComponent * 255.0)
            let blue = Int(self.blueComponent * 255.0)
            // let alpha = self.alphaComponent
            return (red << 16) + (green << 8) + blue
        #endif
    }
}

 