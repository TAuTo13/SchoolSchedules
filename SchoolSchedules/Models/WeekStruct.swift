//
//  WeekStruct.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/29.
//

import Foundation

struct WeekStruct{
    private(set) var weekOfYear: Int
    private(set) var year: Int
    private(set) var month: String
    private var calendar: Calendar
    private var formatter = DateFormatter()
    private var date: Date
    
    init(_ weekOfYear: Int, _ year: Int, calendar: Calendar = Calendar.current) throws {
        formatter.locale = Locale(identifier: "en_US")
        self.weekOfYear = weekOfYear
        self.year = year
        self.calendar = calendar
        
        guard let date = calendar.date(from: DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year))
        else{
            throw DateException.NotFoundException
        }
        
        self.date = date
        
        let month = calendar.component(.month, from: date)

        self.month = formatter.shortMonthSymbols[month - 1]
    }
    
    private mutating func update(){
        let cp = calendar.dateComponents([.year, .weekOfYear, .month], from: date)
        self.year = cp.year!
        self.weekOfYear = cp.weekOfYear!
        self.month = calendar.shortMonthSymbols[cp.month! - 1]
    }
    
    public mutating func increment() throws {
        guard let date_optional = calendar.date(byAdding: .weekOfYear, value: 1, to: date)else{
            throw DateException.NotFoundException
        }
        date = date_optional
        update()
    }
    
    public mutating func decrement() throws {
        guard let date_optional = calendar.date(byAdding: .weekOfYear, value: -1, to: date)
        else {
            throw DateException.NotFoundException
        }
        date = date_optional
        update()
    }
    
    public func getDayOfWeek(weekday: Int) throws -> Date {
        guard let date = calendar.date(from: DateComponents(weekday: weekday, weekOfYear: weekOfYear, yearForWeekOfYear: year))
        else {
            throw DateException.NotFoundException
        }
        
        return date
    }
}
