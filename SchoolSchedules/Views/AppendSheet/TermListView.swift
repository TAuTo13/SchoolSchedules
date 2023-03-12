//
//  TermListView.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/06.
//

import SwiftUI
import RealmSwift

struct TermListView: View {
    @Binding var resultTerm: Term?
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedResults(Term.self) private var termList
    
    @State private var selectedTerm: Term? = nil
    
    @State private var termSelected = false
    
    @State private var deleteActionSheet = false
    
    var body: some View {
        NavigationStack{
            if let termList = termList{
                List(selection: $selectedTerm){
                    ForEach(termList, id: \.self){ t in
                        Text("\(t.year) \(t.segment) \(t.subSegment)")
                    }
                }
                .onChange(of: selectedTerm){ _ in
                    termSelected = true
                }
            }else{
                Text("No Terms found.")
            }
            
        }
        .navigationTitle("Term List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){

                    Button{
                        resultTerm = selectedTerm
                        dismiss()
                    }label: {
                        Text("Select")
                    }
                    .disabled(!termSelected)

                }
                ToolbarItem(placement: .bottomBar){
                    HStack{
                        Button(role:.destructive){
                            deleteActionSheet = true
                        }label:{
                            Image(systemName: "trash")
                        }
                        .disabled(!termSelected)
                        .actionSheet(isPresented: $deleteActionSheet){
                            ActionSheet(title: Text("Do you want to delete?"),buttons: [
                                .destructive(Text("Delete")){
                                    deleteTerm()
                                },
                                .cancel()
                            ])
                        }

                        NavigationLink(destination: AddTermView(itemToEdit: selectedTerm),
                                       label: {Image(systemName: "pencil")})
                        .disabled(!termSelected)

                        NavigationLink(destination: AddTermView(), label: {Image(systemName: "plus")})
                    }
                }
            }
    }
    
    private func deleteTerm(){
        do{
            let realm = try Realm()
            let subjects = realm.objects(SubjectItem.self).where({$0.term.id == selectedTerm!.id})

            if subjects.count == 0 {
                $termList.remove(selectedTerm!)
                
                selectedTerm = nil
                termSelected = false
            }
        }catch{
            print(error)
        }
    }
}

struct TermListView_Previews: PreviewProvider {
    @State static var term: Term? = nil

    static var previews: some View {
        NavigationView{
            TermListView(resultTerm: $term)
        }
    }
}
