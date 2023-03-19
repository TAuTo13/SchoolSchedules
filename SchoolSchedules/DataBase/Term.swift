//
//  Term.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/21.
//

import Foundation
import RealmSwift

final class Term:Object,ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var year: Int
    
    @Persisted var segment: String
    
    @Persisted var subSegment: String
    
    @Persisted var startDate: Date
    
    @Persisted var subjects = RealmSwift.List<SubjectItem>()
    
    static func == (left: Term, right: Term) -> Bool{
        return left.year == right.year &&
        left.segment == right.segment &&
        left.subSegment == right.subSegment
    }
}
