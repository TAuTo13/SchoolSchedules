//
//  DayStrunct.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/29.
//

import Foundation
import HolidayJp

struct DateStruct {
    private(set) var year: Int
    private(set) var day: Int
    private(set) var weekday: String
    private(set) var weekdayVal: Int
    private(set) var weekOfYear: Int
    private(set) var month: String
    private(set) var monthVal: Int
    private(set) var isHoliday: Bool
    private(set) var calendar: Calendar
    private(set) var date: Date
    //formatter for represent date in English
    private var formatter = DateFormatter()
    
    
    init(date: Date, calendar: Calendar = Calendar.current) throws {
        self.calendar = calendar
        self.date = date
        formatter.locale = Locale(identifier: "en_US")
        
        let cp = calendar.dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: date)
        
        guard let year = cp.year else { throw DateException.NotFoundException }
        self.year = year
        
        guard let month = cp.month else { throw DateException.NotFoundException }
        self.monthVal = month
        self.month = formatter.shortMonthSymbols[month-1]
        
        guard let day = cp.day else { throw DateException.NotFoundException }
        self.day = day
        
        guard let weekday = cp.weekday else { throw DateException.NotFoundException }
        self.weekdayVal = weekday
        self.weekday = formatter.shortWeekdaySymbols[weekday-1]
        
        guard let weekOfYear = cp.weekOfYear else { throw DateException.NotFoundException }
        self.weekOfYear = weekOfYear
        
        isHoliday = HolidayJp.isHoliday(date, calendar: calendar)
    }
    
    mutating func update() throws {
        let cp = calendar.dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: date)
        
        guard let year = cp.year else {
            throw DateException.NotFoundException
        }
        self.year = year
        
        guard let month = cp.month else {
            throw DateException.NotFoundException
        }
        self.month = formatter.shortMonthSymbols[month-1]
        
        guard let day = cp.day else {
            throw DateException.NotFoundException
        }
        self.day = day
        
        guard let weekday = cp.weekday else {
            throw DateException.NotFoundException
        }
        self.weekday = formatter.shortWeekdaySymbols[weekday-1]
        
        guard let weekOfYear = cp.weekOfYear else {
            throw DateException.NotFoundException
        }
        self.weekOfYear = weekOfYear
        
        isHoliday = HolidayJp.isHoliday(date, calendar: calendar)
    }
    
    mutating func addDays(value:Int) throws {
        guard let resultDate = calendar.date(byAdding: .day, value: value, to: self.date)
        else{
            throw DateException.NotFoundException
        }
        
        self.date = resultDate
        
        do {
            try update()
        } catch {
            throw error
        }
    }
    
    mutating func incrementWeek() throws {
        do {
            try addDays(value: 7)
        } catch {
            throw error
        }
    }
}
