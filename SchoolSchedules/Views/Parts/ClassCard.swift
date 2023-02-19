//
//  ClassRect.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/18.
//

import SwiftUI
//param time and weekday and query subject use both values.
//


struct ClassCard: View {
    let subjectItem: SubjectItem
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
        .fill(.blue)
        .overlay(){
            VStack{
                    Text(subjectItem.name)
                        .font(.title3)
                    Text(subjectItem.room)
                        .font(.caption)
            }
        }
    }
}

struct ClassCard_Previews: PreviewProvider {
    static let subject = SubjectItem(value:["name": "Math",
                                     "room": "A-106",
                                     "teach": "Mr.Kitazaki",
                                     "weeks": 7,
                                     "day": 3,
                                     "time": 2,
                                     "memo": "memo"])
    static var previews: some View {
        ClassCard(subjectItem: subject)
//        ClassCard()
    }
}
