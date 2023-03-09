//
//  NewSubject.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/07.
//

import SwiftUI
import RealmSwift

struct ScheduleStock: Identifiable{
    var id = UUID()
    var weekDay : Int
    var time : Int
}

struct NewSubjectView: View {
    @Environment(\.dismiss) var dismiss
    
    //Realms
    @ObservedResults(SubjectItem.self) var subjectList
    @ObservedResults(ScheduleItem.self) var scheduleList
    
    //for SubjectItems
    @State private var subjectName : String = ""
    @State private var room : String = ""
    @State private var teacher: String = ""
    @State private var weekDay: Int? = nil
    @State private var time: Int? = nil
    @State private var term: Term? = nil
    @State private var color: Color = Color.blue
    @State private var memo: String = ""
    @State private var stock = [ScheduleStock]()
     
    //for checking form state
    @State private var isCompleted = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header:Text("Subject Detail")){
                    TextField("Subject Name", text: $subjectName)
                    TextField("Room Number", text: $room)
                    TextField("Teacher Name", text: $teacher)
                    
                    ColorPicker("Color", selection: $color)
                    
                    HStack{
                        Text("Memo")
                        TextEditor(text: $memo)
                    }
                }
                
                Section(header: Text("Subject Schedule")){
                    VStack{
                        List{
                            ForEach(stock){ item in
                                StockRow(scheduleItem: item)
                            }
                        }
                        Button{
                            AddStock()
                        } label:{
                            Text("Add")
                        }.disabled(!StockFullfilled())
                    }
                    Picker(selection: $weekDay, label: Text("WeekDay")){
                        Text("Monday").tag(Optional(1))
                        Text("Tuesday").tag(Optional(2))
                        Text("Wednesday").tag(Optional(3))
                        Text("Thrusday").tag(Optional(4))
                        Text("Friday").tag(Optional(5))
                    }
                    Picker(selection: $time, label: Text("Time")){
                        Text("1 (8:50 ~ 10:20)").tag(Optional(1))
                        Text("2 (10:30 ~ 12:00)").tag(Optional(2))
                        Text("3 (12:50 ~ 14:20)").tag(Optional(3))
                        Text("4 (14:30 ~ 16:00)").tag(Optional(4))
                        Text("5 (16:10 ~ 17:40)").tag(Optional(5))
                        Text("6 (17:50 ~ 19:20)").tag(Optional(5))
                    }
                    //select terms
                    NavigationLink{
                        TermListView(resultTerm: $term)
                    } label: {
                        let year = (term == nil) ? "" : "\(term!.year)"
                        let segment = (term == nil) ? "" : term!.segment
                        let subSegment = (term == nil) ? "" : term!.subSegment
                        Text("Term: \(year) \(segment) \(subSegment)")
                    }
                    
                }
            }
        }
        .navigationTitle("New Subject")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    AddSubject()
                    dismiss()
                }label: {
                    Text("Finish")
                }.disabled(!SubjectFullfilled())
            }
        }
    }
    
    
    
    private func SubjectFullfilled() -> Bool{
        let roomPattern = "^[a-zA-Z][1-9]*-[1-9][0-9][1-9]$"
        
        if stock.count>0
            && !subjectName.isEmpty
            && room.range(of: roomPattern,options: .regularExpression) != nil
            && !teacher.isEmpty
            && weekDay != nil
            && time != nil
            && term != nil
        {
            return true
        }
        
        return false
    }
    
    private func StockFullfilled() -> Bool{
        if weekDay != nil && time != nil{
            return true
        }
        return false
    }
    
    
    
    private func AddStock(){
        if term == nil || weekDay == nil || time == nil{
            return
        }
        
        if subjectList.where({$0.term == term! && $0.day == weekDay!
            && $0.time == time!}).count == 0{
            stock.append(ScheduleStock(weekDay:weekDay!,time:time!))
        }
    }
    
    private func AddSubject(){
        for scheduleItem in stock{
            let subject = SubjectItem(value:["name": subjectName,
                                             "room": room,
                                             "teach": teacher,
                                             "color":color.toHex()!,
                                             "day": scheduleItem.weekDay,
                                             "time": scheduleItem.time,
                                             "memo": memo])
            $subjectList.append(subject)
            AddSchedulesFromSubject(subject)
        }

    }
    
    private func AddSchedulesFromSubject(_ subject: SubjectItem){
        let weekdays = 7
        let term: Term = subject.term!
        let weeks = subject.term!.subSegment == TermSubSegment.Full.rawValue ?
            TermDefinition.FULL_TERM_WEEKS : TermDefinition.HALF_TERM_WEEKS
        
        var date = try! DateStruct(date: term.startDate)
        if subject.day > date.weekdayVal{
            let _ = date.addDays(value: subject.day - date.weekdayVal)
            while date.isHoliday { let _ = date.incrementWeek() }
        }else{
            let _ = date.addDays(value: weekdays - date.weekdayVal + subject.day)
            while date.isHoliday { let _ =  date.incrementWeek() }
        }
        
        for _ in 0..<weeks{
            let scheduleItem = ScheduleItem(value: ["subjectItem":subject,
                                                    "term": term,
                                                    "date":date.date,
                                                    "room":subject.room,
                                                    "time":subject.time])
            
            $scheduleList.append(scheduleItem)
            
            let _ = date.incrementWeek()
            while date.isHoliday { let _ = date.incrementWeek() }
        }
    }
}

struct StockRow: View{
    let scheduleItem: ScheduleStock
    
    func RowView() -> some View{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return Label(
            title: {Text("\(formatter.weekdaySymbols[scheduleItem.weekDay]) \(scheduleItem.time)")},
            icon: {Image(systemName: "calendar")}
        )
    }
    
    var body: some View{
        RowView().padding(.leading)
    }
}

struct NewSubject_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NewSubjectView()
        }
    }
}
