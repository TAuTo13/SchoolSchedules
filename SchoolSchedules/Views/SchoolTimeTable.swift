//
//  SchoolScheduleView.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/18.
//

import SwiftUI
import RealmSwift

struct SchoolClass{
    let name: String
}

struct SchoolTimeTable: View {
    @State private var week : WeekStruct = DateHelper().getWeekNow()
    
    @EnvironmentObject private var store: DbStore
    
    private let margin:CGFloat = 5
    private let headerSizeXRatio = 0.9
    private let headerSizeYRatio = 0.1
    private let headerYearYRatio = 0.35
    
    func UICalenderView() -> some View{
        let sideMargin = margin * 2
        let headerDaysYRatio = 1 - headerYearYRatio
        
        let timesXRatio = 1 - headerSizeXRatio
        let timesYRatio = 1 - headerSizeYRatio
        
        let drawableSpaceHeight = UIScreen.main.bounds.height
        let drawableSpaceWidth = UIScreen.main.bounds.width
        
        let timesWidth = drawableSpaceWidth * timesXRatio - sideMargin
        let timesHeight = (drawableSpaceHeight * timesYRatio) / 6 - margin * 4
        let headerHeight = drawableSpaceHeight * headerSizeYRatio
        let daySpaceWidth = drawableSpaceWidth * headerSizeXRatio * 0.2 - margin
        
        let view =
            NavigationStack{
                ZStack {
                    VStack(spacing: margin){
                        Spacer()
                        HStack (spacing: (drawableSpaceWidth / CGFloat(8.0))){
                            Button(){
                                do{
                                    try week.decrement()
                                }catch{
                                    print("exception")
                                }
                            } label: {
                                Text("<Prev")
                            }
                            Text(verbatim: "\(week.month) \(week.year)")
                                .font(.title)
                            Button(){
                                do{
                                    try week.increment()
                                }catch{
                                    print("exception")
                                }
                            } label:{
                                Text("Next>")
                                
                            }
                        }.frame(height: headerHeight * headerYearYRatio)
        
                        
                        HStack(spacing: margin) {
                            Rectangle()
                                .frame(width: timesWidth,
                                       height: headerHeight * headerDaysYRatio)
                                .hidden()
                            ForEach(2..<7) { weekday_current in
                                VStack{
                                    let date = try! DateHelper().getDayFromWeekOfYear(year: week.year, weekOfYear: week.weekOfYear, weekDay: weekday_current)
                                    //weekday
                                    Text(date.weekday)
                                    //day
                                    Text("\(date.day)")
                                        .font(.title2)
                                        .foregroundColor(date.isHoliday ? Color.red : Color.black)
                                }
                                .frame(width: daySpaceWidth,
                                       height: headerHeight * headerDaysYRatio)
                            }
                        }
                        
                        Divider()
                        
                        //Timetable Section
                        ScrollView{
                            VStack {
                                HStack(spacing: margin){
                                    VStack(spacing: margin){
                                        ForEach(1..<7){time_current in
                                            Text(String(time_current))
                                                
                                        }.position(x:timesWidth * 0.5 + margin,
                                                   y:drawableSpaceHeight * headerSizeYRatio - margin * 6)
                                         .frame(width: timesWidth,
                                                height: timesHeight)
                                    }.frame(width: timesWidth,alignment: .trailing)
                                    
                                    HStack(spacing: margin){
                                        ForEach(2..<7){weekday in
                                            VStack (spacing: margin){
                                                ForEach(1..<7){ time in
                                                    let classView = try! SetSubjectSchedule(weekday: weekday, time: time)
                                                    classView
                                                        .frame(width: daySpaceWidth,
                                                               height: timesHeight)
                                                        
                                                }
                                            }
                                        }
                                    }
                                }
                                Spacer(minLength: 100)
                            }
                        }
                    }.frame(height: drawableSpaceHeight - headerHeight )
                    AppendButton()
                }
            }
        
        return view
    }
    
    func SetSubjectSchedule(weekday: Int, time: Int) throws -> some View{
        do{
            let date: Date = try week.getDayOfWeek(weekday: weekday)
            let schedules = store.ScheduleEntities.where({$0.date == date && $0.time == time})
            
            if let schedule = schedules.first {
                return ClassCard(subjectItem: schedule.subjectItem.first!)
            } else {
                return ClassCard(subjectItem: nil)
            }
        }catch{
            print(error)
            throw DateException.NotFoundException
        }
    }
    
    var body: some View {
        UICalenderView()
    }
}

struct SchoolTimeTable_Previews: PreviewProvider {
  static var previews: some View {
//        var calendar = Calendar.current
//        calendar.locale=Locale("ja_JP")
//        let date = Date()
//        let weeknum = calendar.component(.weekOfYear, from: date)
//
        SchoolTimeTable()
    }
}
