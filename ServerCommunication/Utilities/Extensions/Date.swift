//
//  Date.swift
//  TonnijAppNew
//
//  Created by Aditya Sharma on 12/10/19.
//  Copyright © 2019 Mohit Chaudhary. All rights reserved.
//

import Foundation

public extension Date {
    
    func monthStartDate() -> Date{
        let newDateStr = "\(FODataUtils.stringFromDate(self, format: "MM")!)/01/\(FODataUtils.stringFromDate(self, format: "yyyy")!)"
        return FODataUtils.dateFromString(newDateStr, format: "MM/dd/yyyy")!
    }
    
     func monthEndDate() -> Date{
        return FODataUtils.nextMonthStartDate(self.monthStartDate()).addingTimeInterval(-24*60*60)
    }
    
    func getDifferenceFromDate(date: Date , format : String? = "MM/dd/yyyy") -> DateComponents{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format//ModelManager.singleton.dataForCustomer.intgDateTimeFormat
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        return Calendar.current.dateComponents(components, from: self, to: date)
    }

    func getNextMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
      func getPreviousMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
     func getNextMonthEndDate() -> Date {
        return getNextMonth().monthEndDate()
    }
    
     func getPrevMonthStartDate() -> Date  {
        return getPreviousMonth().monthStartDate()
    }
    
     func getNextMonthStartDate() -> Date {
        return getNextMonth().monthStartDate()
    }
    
    //RECHECK - NO Check for HR will be here
     func stringValue (_ format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
     func dateWithTime(time: String,format:String = "MM/dd/yyyy hh:mm a") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: "\(self) \(time)")
    }
    
     func dateWithOutTime(format : String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: "\(self)")!
    }
    
     func firstDayOfWeek(firstDay:Int) -> Date {
        var gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorianCalendar.timeZone = TimeZone(abbreviation: "UTC")!
        let comp = gregorianCalendar.dateComponents([Calendar.Component.day, .month, .year, .weekday], from: self)
        gregorianCalendar.firstWeekday = firstDay
        let startOfDay = gregorianCalendar.date(from: comp)
        var diff = gregorianCalendar.firstWeekday - comp.weekday!
        if diff > 0 {
            diff = diff - 7
        }
        var subtractComponent = DateComponents()
        subtractComponent.day = diff
        return (gregorianCalendar.date(byAdding: subtractComponent, to: startOfDay!))!
    }
    
     func endDayOfWeek(firstDay : Int) -> Date {
        return self.firstDayOfWeek(firstDay: firstDay).offsetBy(.day, count: 6)
    }
    
     func isEqual(to date:Date) -> Bool {
        return self.compare(date) == .orderedSame
    }

    var millisecondsSince1970: Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()

    }
    
    init(milliseconds: Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    var nextHour: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let minutes = calendar.component(.minute, from: self)
        let components = DateComponents(hour: 1, minute: -minutes)
        return calendar.date(byAdding: components, to: self) ?? self
    }

    // MARK: Compare Dates
    
    /// Compares dates to see if they are equal while ignoring time.
    func compare(_ comparison:DateComparisonType) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        var today = FODataUtils.getCurrentDateTimeForSettings()
        today = today.dateFor(.startOfDay, calendar: calendar)
        switch comparison {
        case .isToday:
            return compare(.isSameDay(as: today))
        case .isTomorrow:
            let comparison = today.offsetBy(.day, count:1)
            return compare(.isSameDay(as: comparison))
        case .isYesterday:
            let comparison = today.offsetBy(.day, count: -1)
            return compare(.isSameDay(as: comparison))
        case .isDayAfterTommorow :
            let comparison = today.offsetBy(.day, count: 2)
            return compare(.isSameDay(as: comparison))
        case .isSameDay(let date):
            return self.compare(date) == .orderedSame
        case .isThisWeek:
            return self.compare(.isSameWeek(as: today))
        case .isNextWeek:
            let comparison = today.offsetBy(.week, count:1)
            return compare(.isSameWeek(as: comparison))
        case .isLastWeek:
            let comparison = today.offsetBy(.week, count:-1)
            return compare(.isSameWeek(as: comparison))
        case .isSameWeek(let date):
            if component(.week) != date.component(.week) {
                return false
            }
            // Ensure time interval is under 1 week
            return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
        case .isThisMonth:
            return self.compare(.isSameMonth(as: today))
        case .isNextMonth:
            let comparison = today.offsetBy(.month, count:1)
            return compare(.isSameMonth(as: comparison))
        case .isLastMonth:
            let comparison = today.offsetBy(.month, count:-1)
            return compare(.isSameMonth(as: comparison))
        case .isSameMonth(let date):
            return component(.year) == date.component(.year) && component(.month) == date.component(.month)
        case .isThisYear:
            return self.compare(.isSameYear(as: Date()))
        case .isNextYear:
            let comparison = today.offsetBy(.year, count:1)
            return compare(.isSameYear(as: comparison))
        case .isLastYear:
            let comparison = today.offsetBy(.year, count:-1)
            return compare(.isSameYear(as: comparison))
        case .isSameYear(let date):
            return component(.year) == date.component(.year)
        case .isInTheFuture:
            return self.compare(.isLater(than: today))
        case .isInThePast:
            return self.compare(.isEarlier(than: today))
        case .isEarlier(let date):
            return self.compare(date) == .orderedAscending
        case .isLater(let date):
            return self.compare(date) == .orderedDescending
        case .isWeekday:
            return !compare(.isWeekend)
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
        
    }
    
    
    // MARK: Adjust dates
    
    /// Creates a new date with adjusted components
    
    func offsetBy(_ component:DateComponentType, count: Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = count
        case .minute:
            dateComp.minute = count
        case .hour:
            dateComp.hour = count
        case .day:
            dateComp.day = count
        case .weekday:
            dateComp.weekday = count
        case .nthWeekday:
            dateComp.weekdayOrdinal = count
        case .week:
            dateComp.weekOfYear = count
        case .month:
            dateComp.month = count
        case .year:
            dateComp.year = count
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    /// Return a new Date object with the new hour, minute and seconds values.
    func adjust(hour: Int?, minute: Int?, second: Int?, day: Int? = nil, month: Int? = nil) -> Date {
        var comp = Date.components(self)
        comp.month = month ?? comp.month
        comp.day = day ?? comp.day
        comp.hour = hour ?? comp.hour
        comp.minute = minute ?? comp.minute
        comp.second = second ?? comp.second
        return Calendar.current.date(from: comp)!
    }
    
    // MARK: Date for...
    
    func dateFor(_ type:DateForType, calendar:Calendar = Calendar.current) -> Date {
        switch type {
        case .startOfDay:
            return adjust(hour: 0, minute: 0, second: 0)
        case .endOfDay:
            return adjust(hour: 23, minute: 58, second: 58)
        case .startOfMonth:
            return self.monthStartDate()
        case .endOfMonth:
            return self.monthEndDate()
        case .tomorrow:
            return offsetBy(.day, count:1)
        case .yesterday:
            return offsetBy(.day, count:-1)
        case .nearestMinute(let nearest):
            let minutes = (component(.minute)! + nearest/2) / nearest * nearest
            return adjust(hour: nil, minute: minutes, second: nil)
        case .nearestHour(let nearest):
            let hours = (component(.hour)! + nearest/2) / nearest * nearest
            return adjust(hour: hours, minute: 0, second: nil)
        }
    }
    
    // MARK: Time since...
    
    func since(_ date:Date, in component:DateComponentType) -> Int64 {
        switch component {
        case .second:
            return Int64(timeIntervalSince(date))
        case .minute:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.minuteInSeconds)
        case .hour:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.hourInSeconds)
        case .day:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .day, in: .era, for: self)
            let start = calendar.ordinality(of: .day, in: .era, for: date)
            return Int64(end! - start!)
        case .weekday:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekday, in: .era, for: self)
            let start = calendar.ordinality(of: .weekday, in: .era, for: date)
            return Int64(end! - start!)
        case .nthWeekday:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: self)
            let start = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: date)
            return Int64(end! - start!)
        case .week:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekOfYear, in: .era, for: self)
            let start = calendar.ordinality(of: .weekOfYear, in: .era, for: date)
            return Int64(end! - start!)
        case .month:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .month, in: .era, for: self)
            let start = calendar.ordinality(of: .month, in: .era, for: date)
            return Int64(end! - start!)
        case .year:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .year, in: .era, for: self)
            let start = calendar.ordinality(of: .year, in: .era, for: date)
            return Int64(end! - start!)
            
        }
    }
    
    
    // MARK: Extracting components
    
    func component(_ component:DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    func numberOfDaysInMonth() -> Int {
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!
        return range.upperBound - range.lowerBound
    }
    
    func firstDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    func lastDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    
    // MARK: Internal Components
    
    internal static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    // MARK: Intervals In Seconds
    internal static let minuteInSeconds:Double = 60
    internal static let hourInSeconds:Double = 3600
    internal static let dayInSeconds:Double = 86400
    internal static let weekInSeconds:Double = 604800
    internal static let yearInSeconds:Double = 31556926
    
}

public enum DateFormatType {
    
    /// The ISO8601 formatted year "yyyy" i.e. 1997
    case isoYear
    
    /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
    case isoYearMonth
    
    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate
    
    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
    case isoDateTime
    
    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
    case isoDateTimeSec
    
    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec
    
    /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
    case dotNet
    
    /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
    case rss
    
    /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
    case altRSS
    
    /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
    case httpHeader
    
    /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
    case standard
    
    /// A custom date format string
    case custom(String)
    
    var stringFormat:String {
        switch self {
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .dotNet: return "/Date(%d%f)/"
        case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
        case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    case local, utc
    var timeZone:TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .utc: return TimeZone(secondsFromGMT: 0)!
        }
    }
}

// The string keys to modify the strings in relative format
public enum RelativeTimeStringType {
    case nowPast, nowFuture, secondsPast, secondsFuture, oneMinutePast, oneMinuteFuture, minutesPast, minutesFuture, oneHourPast, oneHourFuture, hoursPast, hoursFuture, oneDayPast, oneDayFuture, daysPast, daysFuture, oneWeekPast, oneWeekFuture, weeksPast, weeksFuture, oneMonthPast, oneMonthFuture, monthsPast, monthsFuture, oneYearPast, oneYearFuture, yearsPast, yearsFuture
}

// The type of comparison to do against today's date or with the suplied date.
public enum DateComparisonType {
    
    // Days
    
    /// Checks if date today.
    case isToday
    /// Checks if date is tomorrow.
    case isTomorrow
    /// Checks if date is yesterday.
    case isYesterday
    /// Checks if date is day after tommorow
    case isDayAfterTommorow
    /// Compares date days
    case isSameDay(as:Date)
    
    // Weeks
    
    /// Checks if date is in this week.
    case isThisWeek
    /// Checks if date is in next week.
    case isNextWeek
    /// Checks if date is in last week.
    case isLastWeek
    /// Compares date weeks
    case isSameWeek(as:Date)
    
    // Months
    
    /// Checks if date is in this month.
    case isThisMonth
    /// Checks if date is in next month.
    case isNextMonth
    /// Checks if date is in last month.
    case isLastMonth
    /// Compares date months
    case isSameMonth(as:Date)
    
    // Years
    
    /// Checks if date is in this year.
    case isThisYear
    /// Checks if date is in next year.
    case isNextYear
    /// Checks if date is in last year.
    case isLastYear
    /// Compare date years
    case isSameYear(as:Date)
    
    // Relative Time
    
    /// Checks if it's a future date
    case isInTheFuture
    /// Checks if the date has passed
    case isInThePast
    /// Checks if earlier than date
    case isEarlier(than:Date)
    /// Checks if later than date
    case isLater(than:Date)
    /// Checks if it's a weekday
    case isWeekday
    /// Checks if it's a weekend
    case isWeekend
    
}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}


// The type of date that can be used for the dateFor function.
public enum DateForType {
    case startOfDay, endOfDay, startOfMonth, endOfMonth, tomorrow, yesterday, nearestMinute(minute:Int), nearestHour(hour:Int)
}

// Convenience types for date to string conversion
public enum DateStyleType {
    /// Short style: "2/27/17, 2:22 PM"
    case short
    /// Medium style: "Feb 27, 2017, 2:22:06 PM"
    case medium
    /// Long style: "February 27, 2017 at 2:22:06 PM EST"
    case long
    /// Full style: "Monday, February 27, 2017 at 2:22:06 PM Eastern Standard Time"
    case full
    /// Ordinal day: "27th"
    case ordinalDay
    /// Weekday: "Monday"
    case weekday
    /// Short week day: "Mon"
    case shortWeekday
    /// Very short weekday: "M"
    case veryShortWeekday
    /// Month: "February"
    case month
    /// Short month: "Feb"
    case shortMonth
    /// Very short month: "F"
    case veryShortMonth
}
