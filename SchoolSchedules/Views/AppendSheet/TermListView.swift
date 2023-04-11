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
    
    @EnvironmentObject private var store: DbStore
    
    @ObservedResults(Term.self) private var termList
    
    @State private var selectedTerm: Term? = nil
    
    @State private var deleteActionSheet = false
    
    @State private var errorForAlert: ErrorMessage?
    
    var body: some View {
        NavigationStack{
            List(selection: $selectedTerm){
                ForEach(termList, id: \.self){ t in
                    if t.isInvalidated {
                        EmptyView()
                    }else{
                        Text("\(t.year) \(t.segment)")
                    }
                }
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
                    .disabled(!termSelected())

                }
                ToolbarItem(placement: .bottomBar){
                    HStack{
                        Button(role:.destructive){
                            deleteActionSheet = true
                        }label:{
                            Image(systemName: "trash")
                        }
                        .disabled(!termSelected())
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
                        .disabled(!termSelected())

                        NavigationLink(destination: AddTermView(), label: {Image(systemName: "plus")})
                    }
                }
            }
            .alert(item: $errorForAlert) { error in
                Alert(title: Text(error.title),message: Text(error.message), dismissButton: .default(Text("OK")))
            }
    }
    
    private func deleteTerm(){
        do {
            try store.deleteTerm(selectedTerm!)
        } catch DbException.TermModifyLockException(let description) {
            errorForAlert = ErrorMessage(title: "ModifyLockError", message: description)
        } catch {
            errorForAlert = ErrorMessage(title: "RealmError", message: error.localizedDescription)
        }
        selectedTerm = nil
    }
    
    private func termSelected() -> Bool {
        if let _ = selectedTerm {
            return true
        }
        return false
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
