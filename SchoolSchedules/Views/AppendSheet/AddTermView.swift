//
//  AddTermView.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/06.
//

import SwiftUI
import RealmSwift

struct AddTermView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var store: DbStore
    
    private let current_year: Int = DateHelper().getYearNow()
    
    private var itemToEdit: Term?
    
    //for Terms
    @State private var year: Int = DateHelper().getYearNow()
    @State private var termSegment: TermSegment = .Front
    @State private var termSubSegment: TermSubSegment = .Full
    @State private var startDate: Date = Calendar.current.date(from: DateComponents(year: DateHelper().getYearNow(), month: 4, day: 1))!
    
    @State private var errorForAlert: ErrorMessage?
    
    init(itemToEdit: Term? = nil){
        self.itemToEdit = itemToEdit
        if let itemToEdit = itemToEdit {
            _year = State(initialValue: itemToEdit.year)
            _termSegment = State(initialValue: TermSegment(rawValue: itemToEdit.segment)!)
            _termSubSegment = State(initialValue: TermSubSegment(rawValue: itemToEdit.subSegment)!)
            _startDate = State(initialValue: itemToEdit.startDate)
        }
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Term")){
                    Picker(selection: $year, label: Text("Year")){
                        ForEach(current_year ..< (current_year + 5),
                                id: \.self){ y in
                            Text("\(y)")
                        }
                    }.onChange(of: year){ _ in
                        onSelectionChanged()
                    }
                    
                    Picker(selection: $termSegment ,label: Text("Segment")){
                        Text("Front term").tag(TermSegment.Front)
                        Text("Back term").tag(TermSegment.Back)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: termSegment){ _ in
                        onSelectionChanged()
                    }
                    
                    Picker(selection: $termSubSegment ,label: Text("SubSegment")){
                        Text("1st").tag(TermSubSegment.First)
                        Text("2nd").tag(TermSubSegment.Second)
                        Text("Full").tag(TermSubSegment.Full)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: termSubSegment){ _ in
                        onSelectionChanged()
                    }
                    
                    //start date 1st->4-8, 2nd->9-n.y. 3
                    DatePicker("StartDate",selection: $startDate,in:termRange(),
                               displayedComponents: [.date])
                }
                
            }
        }.navigationTitle("New Term")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        if let _ = itemToEdit{
                            UpdateTerm()
                        }else{
                            AddTerm()
                        }
                        dismiss()
                    }label: {
                        Text("Save")
                    }
                    .disabled(!TermFullfilled())
                }
            }
        
        .alert(item: $errorForAlert) { error in
            Alert(title: Text(error.title),message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
    
    private func onSelectionChanged(){
        let calendar = Calendar.current
        if termSegment == .Front{
            startDate = calendar.date(from: DateComponents(year: year, month: 4, day: 1))!
        }else{
            startDate = calendar.date(from: DateComponents(year: year, month: 9, day: 1))!
        }
    }
    
    private func TermFullfilled() -> Bool{
        if year >= DateHelper().getYearNow() &&
            termRange().contains(startDate){
            return true
        }
        return false
    }
    
    private func UpdateTerm() {
        let term = Term(value: ["year": year,
                                "segment": termSegment,
                                "subSegment": termSubSegment,
                                "startDate": startDate])
        do {
            try store.updateTerm(term)
        } catch DbException.TermModifyLockException(let description){
            errorForAlert = ErrorMessage(title: "ModifyLockError", message: description)
        } catch DbException.CollisioningException(let description) {
            errorForAlert = ErrorMessage(title: "CollisioningError", message: description)
        } catch {
            errorForAlert = ErrorMessage(title: "RealmError", message: error.localizedDescription)
        }
    }
    
    private func AddTerm(){
        let term = Term(value: ["year": year,
                                "segment": termSegment.rawValue,
                                "subSegment": termSubSegment.rawValue,
                                "startDate": startDate])
        do {
            try store.addTerm(term)
        } catch DbException.CollisioningException(let description){
            errorForAlert = ErrorMessage(title: "CollisioningException", message: description)
        } catch {
            errorForAlert = ErrorMessage(title: "RealmError", message: error.localizedDescription)
        }
    }
    
    private func termRange() -> ClosedRange<Date>{
        let calendar = Calendar.current
        if termSegment == .Front{
            let start = calendar.date(from: DateComponents(year: year, month: 4, day: 1))!
            let end = calendar.date(from: DateComponents(year: year, month: 8, day: 31))!
            return start...end
        }else{
            let start = calendar.date(from: DateComponents(year: year, month: 9, day: 1))!
            let end = calendar.date(from: DateComponents(year: year + 1, month: 3, day: 31))!
            return start...end
        }
    }
}

struct AddTermView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddTermView()
        }
    }
}
