//
//  SubjectItem.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/29.
//

import SwiftUI
import RealmSwift

final class SubjectItem: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var name: String
    
    @Persisted var room: String
    
    @Persisted var teacher: String
    
    //color hex code (String)
    @Persisted var color: String
    
    //1~5(Mon.~Fri)((Sat.))
    @Persisted var weekday: Int
    
    //1~6 time
    @Persisted var time: Int
    
    @Persisted var memo: String
    
    @Persisted(originProperty: "subjects") var term: LinkingObjects<Term>
    
    @Persisted var schedules = RealmSwift.List<ScheduleItem>()
}
