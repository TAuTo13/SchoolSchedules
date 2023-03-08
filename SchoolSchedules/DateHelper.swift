//
//  DateHelper.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/29.
//

import Foundation
import HolidayJp

class DateHelper{
    //Set Japanese locale
    let locale = Locale(identifier: "ja_JP")
    //Get Current Datetime
    let date = Date()
    //Get current type (Gregorian) calendar
    let calendar = Calendar.current
    
    //get current date
    func getDateNow() -> DateStruct {
        return try! DateStruct(date: date, calendar: calendar)
    }
    
    func getYearNow() -> Int {
        return calendar.component(.year, from: date)
    }
    
    func getWeekNow() -> WeekStruct {
        return try! WeekStruct(getWeekOfYearNow(), getYearNow())
    }
    
    //get current weekofyear
    func getWeekOfYearNow() -> Int {
        return calendar.component(.weekOfYear, from: date)
    }
    
    //get date from year(int),weakofyear(int) and weekday(int)
    func getDayFromWeekOfYear(year: Int,weekOfYear: Int, weekDay: Int) throws -> DateStruct {
        guard let dateTmp = calendar.date(from: DateComponents(weekday:weekDay,weekOfYear: weekOfYear,yearForWeekOfYear: year))
                                else {
                                    throw DateException.NotFoundException
                                }
        
        let date = try! DateStruct(date: dateTmp, calendar: calendar)
        
        return date
    }
    
    
}
