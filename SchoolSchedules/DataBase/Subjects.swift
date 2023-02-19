//
//  Subjects.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/09.
//

import SwiftUI
import RealmSwift

final class Subjects: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id : ObjectId
    
    @Persisted var items = RealmSwift.List<SubjectItem>()
}
