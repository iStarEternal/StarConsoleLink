//
//  NSDate-Extension.swift
//  StarConsoleLink
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

import Foundation



// MARK: - 年月日时分秒
extension NSDate {
    
    static var calendar: NSCalendar {
        
        // return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        return NSCalendar.currentCalendar()
    }
    
    typealias DateDetail = (year:Int, month:Int, day:Int, hour:Int, minute:Int, second:Int, weekday:Int)
    
    /// 获取日期的详细信息（年、月、日、时、分、秒、星期）
    func getDateDetails() -> DateDetail {
        
        let flags: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.Second,
            NSCalendarUnit.Weekday
        ]
        let comps: NSDateComponents = NSDate.calendar.components(flags, fromDate: self)
        return (comps.year, comps.month, comps.day, comps.hour, comps.minute, comps.second, comps.weekday)
    }
    
    
    var year: Int {
        return self.getDateDetails().year
    }
    
    var month: Int {
        return self.getDateDetails().month
    }
    
    var weekday: Int {
        return self.getDateDetails().weekday
    }
    
    var day: Int {
        return self.getDateDetails().day
    }
    
    var hour: Int {
        return self.getDateDetails().hour
    }
    
    var minute: Int {
        return self.getDateDetails().minute
    }
    
    var second: Int {
        return self.getDateDetails().second
    }
    
    
    
    
}

// MARK: - Format
extension NSDate {
    
    /// 根据日期及格式返回相对于字符串
    func stringWithFormatString(formatString:String) -> String {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = formatString
        return formatter.stringFromDate(self)
    }
    
    static func dateWithFormat(format: String, dateString: String) -> NSDate? {
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(dateString)
    }
}

extension String {
    
    func dateWithFormat(format: String) -> NSDate? {
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(self)
    }
}



// MARK: - 运算
extension NSDate {
    
    func dateByAddingMinute(minute: Int) -> NSDate {
        let comps = NSDateComponents()
        comps.setValue(minute, forComponent: NSCalendarUnit.Minute)
        return NSDate.calendar.dateByAddingComponents(comps, toDate: self, options: NSCalendarOptions())!
    }
    
    func dateByAddingHour(hour: Int) -> NSDate {
        let comps = NSDateComponents()
        comps.setValue(hour, forComponent: NSCalendarUnit.Hour)
        return NSDate.calendar.dateByAddingComponents(comps, toDate: self, options: NSCalendarOptions())!
    }
    
    /// 添加天
    func dateByAddingDay(day: Int) -> NSDate {
        let comps = NSDateComponents()
        comps.setValue(day, forComponent: NSCalendarUnit.Day)
        return NSDate.calendar.dateByAddingComponents(comps, toDate: self, options: NSCalendarOptions())!
    }
    
    /// 添加月
    func dateByAddingMonth(month: Int) -> NSDate {
        let comp:NSDateComponents = NSDateComponents()
        comp.setValue(month, forComponent: NSCalendarUnit.Month)
        return NSDate.calendar.dateByAddingComponents(comp, toDate: self, options: NSCalendarOptions())!
    }
    
    
    
    /// 当天的第二天
    func nextDay() -> NSDate {
        let comps = NSDateComponents()
        comps.setValue(1, forComponent: NSCalendarUnit.Day)
        return NSDate.calendar.dateByAddingComponents(comps, toDate: self, options: NSCalendarOptions())!
    }
    
    
    /// 去掉时分秒
    var dateByRemovingTime: NSDate {
        
        let flags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let comps: NSDateComponents = NSDate.calendar.components(flags, fromDate: self)
        let newDate: NSDate = NSDate.calendar.dateFromComponents(comps)!
        return newDate
    }
    
}
// MARK: - 取值
extension NSDate {
    
    /// 当月有几周
    var numberOfWeeksInMonth: Int {
        return NSDate.calendar.rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: self).length
    }
    
    /// 当前时间是当月第几周
    var weekNumberInMonth: Int {
        let comps:NSDateComponents = NSDate.calendar.components(NSCalendarUnit.WeekOfMonth, fromDate: self)
        
        return comps.weekOfMonth
    }
    
    /// 当前时间是星期几
    var dayOfWeekForDate: Int {
        let comps: NSDateComponents = NSDate.calendar.components(NSCalendarUnit.Weekday, fromDate: self)
        return comps.weekday
    }
    
    
    /// 当月有多少天
    var numberOfDaysInMonth: Int {
        return NSDate.calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self).length
    }
    
    /// 当月的第一天
    var firstDayInMonth: NSDate {
        
        let flags:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let comps:NSDateComponents = NSDate.calendar.components(flags, fromDate: self)
        comps.setValue(1, forComponent: NSCalendarUnit.Day)
        let newDate:NSDate = NSDate.calendar.dateFromComponents(comps)!
        return newDate
    }
    
    /// 当月的最后一天
    var lastDayInMonth: NSDate {
        let flags:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let comps:NSDateComponents = NSDate.calendar.components(flags, fromDate: self)
        comps.setValue(self.numberOfDaysInMonth, forComponent: NSCalendarUnit.Day)
        let newDate:NSDate = NSDate.calendar.dateFromComponents(comps)!
        return newDate
    }
    
    /// 当前月份是否是指定时间的月份
    func isInMonth(dateMonth: NSDate) -> Bool {
        let CalentarUnit:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.TimeZone]
        
        let comps1:NSDateComponents = NSDate.calendar.components(CalentarUnit, fromDate: dateMonth)
        let comps2:NSDateComponents = NSDate.calendar.components(CalentarUnit, fromDate: self)
        
        return comps1.month == comps2.month
    }
    
    
    
    /// 当前时间是否为今天
    var isToday: Bool {
        return NSDate().dateByRemovingTime == self.dateByRemovingTime
    }
    
    /// 当前时间是否已经过去
    var isPast: Bool {
        return NSDate().compare(self) == NSComparisonResult.OrderedDescending
        
    }
    
    /// 当前时间是否是将来
    var isFuture: Bool {
        return NSDate().compare(self) == NSComparisonResult.OrderedAscending
    }
    
    /// 当天是否已经过去
    var isPastDay: Bool {
        return NSDate().dateByRemovingTime.compare(self.dateByRemovingTime) == NSComparisonResult.OrderedDescending
    }
    
}

// MARK: - Greenwich
extension NSDate {
    
    // 获取格林尼治字符串 忽略毫秒
    func getGreenwichString() -> String{
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        return formatter.stringFromDate(self)
    }
    
    //从格林尼治字符串转换成日期
    static func dateWithGreenwichString(string: String) -> NSDate? {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        let d = formatter.dateFromString(string)
        return d
    }
}

// MARK: - Instant Message
extension NSDate {
    
    
    /// 获得聊天类型时间字符串  返回聊天类型时间字符串
    func getChatDateString() -> String {
        
        // now即为现在的时间，由于后面的NSCalendar可以匹配系统日期所以不用设置local
        let now = NSDate()
        let das = NSCalendar.currentCalendar()
        //        let flags: NSCalendarUnit = [.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit]
        let flags: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute]
        let nowCom = das.components(flags, fromDate: now)
        let timeCom = das.components(flags, fromDate: self)
        // 创建当前和需要计算的components
        // components有之前设置的格式的各种参数
        
        if timeCom.year == nowCom.year {
            if timeCom.month == nowCom.month {
                if timeCom.day == nowCom.day {
                    if timeCom.hour == nowCom.hour {
                        if timeCom.minute == nowCom.minute {
                            return "刚才"
                        }
                        return "\(nowCom.minute - timeCom.minute)分钟前"
                    }
                    else {
                        let minute = String(format: "%02d", timeCom.minute)
                        return "今天 \(timeCom.hour):\(minute)"
                    }
                }
                else {
                    if nowCom.day - timeCom.day == 1 {
                        let minute = String(format: "%02d", timeCom.minute)
                        return "昨天 \(timeCom.hour):\(minute)"
                    }
                    else{
                        return "\(nowCom.day - timeCom.day)天前"
                    }
                }
            }
            else {
                return "\(nowCom.month - timeCom.month)月前"
            }
        }
        else {
            let dateForm = NSDateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd HH:mm"
            let time = dateForm.stringFromDate(self)
            return time
        }
    }
    
}

// MARK: - Deprecated
extension NSDate {
    
    /// 获取星期头显示内容
    static func getDaysOfTheWeek() -> NSArray {
        return ["日", "一", "二", "三", "四", "五", "六"]
    }
    
    /// 根据年、月、日获取日期对象
    static func getDateOfY_M_D(year year:Int, month:Int, day:Int) -> NSDate {
        
        let comps:NSDateComponents = NSDateComponents()
        comps.setValue(year, forComponent: NSCalendarUnit.Year)
        comps.setValue(month, forComponent: NSCalendarUnit.Month)
        comps.setValue(day, forComponent: NSCalendarUnit.Day)
        
        return self.calendar.dateFromComponents(comps)!
    }
    
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedDescending
}

public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame || lhs > rhs
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame || lhs < rhs
}

//public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.compare(rhs) == NSComparisonResult.OrderedSame 
//}



