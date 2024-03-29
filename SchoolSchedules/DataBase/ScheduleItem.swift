//
//  ScheduleItem.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/21.
//

import Foundation
import RealmSwift

final class ScheduleItem: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted(originProperty: "schedules") var subjectItem: LinkingObjects<SubjectItem>
    
    @Persisted var date: Date
    
    @Persisted var room: String
    
    @Persisted var time: Int
}
