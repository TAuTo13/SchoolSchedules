//
//  ContentView.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/18.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedResults(Term.self) var terms
    var body: some View {
        SchoolTimeTable()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
