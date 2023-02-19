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

struct NewSubject: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var subjectName : String = ""
    @State private var room : String = ""
    @State private var teacher: String = ""
    @State private var weeks: Int = 7
    @State private var weekDay: Int = 1
    @State private var time: Int = 1
    @State private var memo: String = ""
    @State private var list = [ScheduleStock]()
    @State private var isCompleted = false
    
    var body: some View {
        NavigationStack {
            Form{
                Section(header:Text("Subject Detail")){
                    TextField("Subject Name", text: $subjectName)
//                        .textFieldStyle(.roundedBorder)
                    TextField("Room Number", text: $room)
//                        .textFieldStyle(.roundedBorder)
                    TextField("Teacher Name", text: $teacher)
//                        .textFieldStyle(.roundedBorder)
                    Picker(selection: $weeks, label: Text("Weeks")){
                        Text("SemiTerm(7 weeks)").tag(7)
                        Text("FullTerm(14 weeks ").tag(14)
                    }
                }
                Section(header:Text("Weekly Schedule")){
                    VStack{
                        List{
                            ForEach(list){ item in
                                StockRow(schedule: item)
                            }
                        }
                        Button{
                            AddStock()
                        } label:{
                            Text("Add")
                        }
                    }
                    Picker(selection: $weekDay, label: Text("WeekDay")){
                        Text("Monday").tag(1)
                        Text("Tuesday").tag(2)
                        Text("Wednesday").tag(3)
                        Text("Thrusday").tag(4)
                        Text("Friday").tag(5)
                    }
                    Picker(selection: $time, label: Text("Time")){
                        Text("1 (8:50 ~ 10:20)").tag(1)
                        Text("2 (10:30 ~ 12:00)").tag(2)
                        Text("3 (12:50 ~ 14:20)").tag(3)
                        Text("4 (14:30 ~ 16:00)").tag(4)
                        Text("5 (16:10 ~ 17:40)").tag(5)
                        Text("6 (17:50 ~ 19:20)").tag(5)
                    }
                }
                Section(header: Text("memo")){
                    TextEditor(text: $memo)
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
                }
            }
        }
    }
    
    func AddStock(){
        list.append(ScheduleStock(weekDay:weekDay,time:time))
    }
    
    func AddSubject(){
        let realm = try! Realm()
        for schedule in list{
            let subject = SubjectItem(value:["name": subjectName,
                                             "room": room,
                                             "teach": teacher,
                                             "weeks": weeks,
                                             "day": schedule.weekDay,
                                             "time": schedule.time,
                                             "meme": memo])
            try! realm.write{
                realm.add(subject)
            }
        }

    }
}

struct StockRow: View{
    let schedule: ScheduleStock
    
    func RowView() -> some View{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return Label(
            title: {Text("\(formatter.weekdaySymbols[schedule.weekDay]) \(schedule.time)")},
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
            NewSubject()
        }
    }
}
