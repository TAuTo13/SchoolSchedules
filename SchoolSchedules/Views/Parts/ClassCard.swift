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
    public let subjectItem: SubjectItem?
    
    private var visible = true
    
    public init(subjectItem: SubjectItem?){
        self.subjectItem = subjectItem
    }
    
    var body: some View {
        if let subjectItem = subjectItem {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: subjectItem.color))
                .overlay(){
                    VStack{
                        Text(subjectItem.name)
                            .font(.title3)
                        Text(subjectItem.room)
                            .font(.caption)
                    }
                }
        }else{
            Rectangle()
                .hidden()
        }
    }
}

struct ClassCard_Previews: PreviewProvider {
    static let subject: SubjectItem? = SubjectItem(value:["name": "Math",
                                     "room": "A-106",
                                     "teach": "Mr.Kitazaki",
                                     "weeks": 7,
                                     "day": 3,
                                            "color":Color.blue.toHex()!,
                                     "time": 2,
                                     "memo": "memo"])
    static var previews: some View {
        ClassCard(subjectItem: subject)
//        ClassCard()
    }
}
