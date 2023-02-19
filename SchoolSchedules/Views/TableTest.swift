//
//  TableTest.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/22.
//

import SwiftUI

struct DayClasses:Identifiable{
    let id = UUID()
    
    let class1: String
    let class2: String
    let class3: String
}

struct TableTest: View {
    var body: some View {
        
        let classes=[
            DayClasses(class1: "Math", class2: "Science", class3: "English"),
            DayClasses(class1: "Science",class2: "Programming",class3: "Math")
        ]
        
        Table(classes){
            TableColumn("class1",value: \.class1)
            TableColumn("class2",value: \.class2)
            TableColumn("class3",value: \.class3)
        }
    }
}

struct TableTest_Previews: PreviewProvider {
    static var previews: some View {
        TableTest()
    }
}
