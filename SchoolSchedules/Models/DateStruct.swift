//
//  DayStrunct.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/29.
//

import Foundation
import HolidayJp

struct DateStruct {
    let year: Int
    let day: Int
    let weekday: String
    let weekOfYear: Int
    let month: String
    let isHoliday: Bool
    //formatter for represent date in English
    private var formatter = DateFormatter()
    
    
    init(date: Date, calendar: Calendar = Calendar.current) throws {
        formatter.locale = Locale(identifier: "en_US")
        
        let cp = calendar.dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: date)
        
        guard let year = cp.year else { throw DateException.NotFoundException }
        self.year = year
        
        guard let month = cp.month else { throw DateException.NotFoundException }
        self.month = formatter.shortMonthSymbols[month-1]
        
        guard let day = cp.day else { throw DateException.NotFoundException }
        self.day = day
        
        guard let weekday = cp.weekday else { throw DateException.NotFoundException }
        self.weekday = formatter.shortWeekdaySymbols[weekday-1]
        
        guard let weekOfYear = cp.weekOfYear else { throw DateException.NotFoundException }
        self.weekOfYear = weekOfYear
        
        isHoliday = HolidayJp.isHoliday(date, calendar: calendar)
    }
}
