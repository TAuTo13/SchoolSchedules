//
//  NewSubject.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/07.
//

import SwiftUI
import RealmSwift

struct ScheduleStock: Identifiable {
    let id = UUID()
    var weekDay : Int
    var time : Int
}

struct NewSubjectView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var store: DbStore
    
    //for SubjectItems
    @State private var subjectName : String = ""
    @State private var room : String = ""
    @State private var teacher: String = ""
    @State private var weekday: Int = 2
    @State private var time: Int = 1
    @State private var term: Term? = nil
    @State private var color: Color = Color.blue
    @State private var memo: String = ""
    @State private var stock = [ScheduleStock]()
     
    //for checking form state
    @State private var isCompleted = false
    
    @State private var errorForAlert: ErrorMessage?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header:Text("Subject Detail")){
                    
                    HStack{
                        Text("Subject Name")
                            .font(.caption)
                        Text(SubjectNameValidMessage())
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    TextField("Subject Name", text: $subjectName)
                    HStack{
                        Text("Room Number")
                            .font(.caption)
                        Text(RoomNumberValidMessage())
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    TextField("Room Number", text: $room)
                    
                    HStack{
                        Text("Teaching by")
                            .font(.caption)
                        Text(TeacherValidMessage())
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    TextField("Teacher Name", text: $teacher)
                    
                    //select terms
                    NavigationLink{
                        TermListView(resultTerm: $term)
                    } label: {
                        if let term = term{
                            let year =  "\(term.year)"
                            let segment = term.segment
                            let subSegment = term.subSegment
                            Text("Term  \(year) \(segment) \(subSegment)")
                        }else{
                            HStack{
                                Text("Term")
                                Text("Required")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    ColorPicker("Color", selection: $color)
                    
                    HStack{
                        Text("Memo")
                        TextEditor(text: $memo)
                    }
                    
                }
                
                Section(header: Text("Subject Schedule")){
                    if !stock.isEmpty{
                        List{
                            ForEach(stock){ item in
                                StockRow(scheduleItem: item)
                            }
                        }
                    }else{
                        Text("Required")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Picker(selection: $weekday, label: Text("WeekDay")){
                        Text("Monday").tag(2)
                        Text("Tuesday").tag(3)
                        Text("Wednesday").tag(4)
                        Text("Thrusday").tag(5)
                        Text("Friday").tag(6)
                    }
                    
                    Picker(selection: $time, label: Text("Time")){
                        Text("1 (8:50 ~ 10:20)").tag(1)
                        Text("2 (10:30 ~ 12:00)").tag(2)
                        Text("3 (12:50 ~ 14:20)").tag(3)
                        Text("4 (14:30 ~ 16:00)").tag(4)
                        Text("5 (16:10 ~ 17:40)").tag(5)
                        Text("6 (17:50 ~ 19:20)").tag(5)
                    }
                    
                    Button{
                        AddStock()
                    } label:{
                        Text("Add")
                    }
                    .disabled(!StockAppendable())
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
        .alert(item: $errorForAlert){ error in
            Alert(title: Text(error.title),message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
    
    private func SubjectNameValidMessage() -> String {
        var message = ""
        if subjectName.isEmpty {
            message = "Required"
        }
        
        return message
    }
    
    private func RoomNumberValidMessage() -> String {
        let roomPattern = "^[a-zA-Z][1-9]*-[1-9][0-9][0-9]$"
        
        var message = ""
        if room.isEmpty {
            message = "Required"
        }else if room.range(of: roomPattern,options: .regularExpression) == nil {
            message = "Wrong format"
        }
        
        return message
    }
    
    private func TeacherValidMessage() -> String {
        var message = ""
        if teacher.isEmpty {
            message = "Required"
        }
        
        return message
    }
    
    private func SubjectFullfilled() -> Bool{
        if stock.count>0
            && SubjectNameValidMessage().isEmpty
            && RoomNumberValidMessage().isEmpty
            && TeacherValidMessage().isEmpty
            && term != nil
        {
            return true
        }
        
        return false
    }

    private func StockAppendable() -> Bool{
        if stock.contains(where: {$0.weekDay == weekday && $0.time == time})
            || term == nil{
            return false
        }
        return true
    }
    
    private func AddStock(){
        // There's No subject same schedule at the same Term
        if let term = term{
            if store.checkSubjectCollisioning(weekday: weekday, time: time, term: term) {
                return
            }
            
            stock.append(ScheduleStock(weekDay: weekday, time: time))
        }
    }
    
    private func AddSubject(){
        for scheduleItem in stock{
            let subject = SubjectItem(value:["name": subjectName,
                                             "room": room,
                                             "teach": teacher,
                                             "color":color.toHex()!,
                                             "weekday": scheduleItem.weekDay,
                                             "time": scheduleItem.time,
                                             "memo": memo])
            do {
                try store.addSubject(subject: subject,term: term!)
            } catch DbException.CollisioningException(let description) {
                errorForAlert = ErrorMessage(title: "CollisioningError",
                                             message: description)
            } catch {
                errorForAlert = ErrorMessage(title: "RealmError", message: error.localizedDescription)
            }
            AddSchedulesFromSubject(subject)
        }

    }
    
    private func AddSchedulesFromSubject(_ subject: SubjectItem){
        let weekdays = 7
        let term: Term = subject.term.first!
        let weeks = subject.term.first!.subSegment == TermSubSegment.Full.rawValue ?
            TermDefinition.FULL_TERM_WEEKS : TermDefinition.HALF_TERM_WEEKS
        
        var date = try! DateStruct(date: term.startDate)
        if subject.weekday > date.weekdayVal{
            try! date.addDays(value: subject.weekday - date.weekdayVal)
            while date.isHoliday { try! date.incrementWeek() }
        }else{
            try! date.addDays(value: weekdays - date.weekdayVal + subject.weekday)
            while date.isHoliday { try! date.incrementWeek() }
        }
        
        for _ in 0..<weeks{
            let scheduleItem = ScheduleItem(value: ["term": term,
                                                    "date":date.date,
                                                    "room":subject.room,
                                                    "time":subject.time])
            do {
                try store.addSchedule(schedule: scheduleItem, subject: subject)
            } catch {
                errorForAlert = ErrorMessage(title: "RealmError", message: error.localizedDescription)
            }
            try! date.incrementWeek()
            while date.isHoliday { try! date.incrementWeek() }
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
