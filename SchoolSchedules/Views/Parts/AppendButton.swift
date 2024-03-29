//
//  AppendButton.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/19.
//

import SwiftUI
import RealmSwift

struct AppendButton: View {
    @State private var isPresented = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                })
                    .frame(width: 60, height: 60)
                    .background(Color(.systemOrange))
                    .cornerRadius(30.0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                    .sheet(isPresented: $isPresented){
                        NavigationStack{
                            NewSubjectView()
                        }
                    }
            }
        }
    }
}

struct AppendButton_Previews: PreviewProvider {
    static var previews: some View {
        AppendButton()
    }
}
