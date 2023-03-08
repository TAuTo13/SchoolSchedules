//
//  Schedule.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/21.
//

import Foundation
import RealmSwift

final class Schedule: Object,ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var schedules = RealmSwift.List<ScheduleItem>()
}
