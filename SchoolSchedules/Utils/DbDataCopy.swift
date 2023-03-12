//
//  DbDataCopy.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/11.
//

import Foundation
import RealmSwift

class DbDataCopy{
    public static func CopyTerm(termOriginal: Term) -> Term{
        let termCopied = Term(value: ["id": termOriginal.id,
                                      "year": termOriginal.year,
                                      "segment": termOriginal.segment,
                                      "subSegment": termOriginal.subSegment,
                                      "startDate": termOriginal.startDate])
        
        return termCopied
    }
    
    public static func CopySubjectItem(subjectOriginal: SubjectItem) -> SubjectItem{
        let subjectCopied = SubjectItem(value: ["_id": subjectOriginal.id,
                                                "name": subjectOriginal.name,
                                                "room": subjectOriginal.room,
                                                "teach": subjectOriginal.teach,
                                                "day": subjectOriginal.day,
                                                "color": subjectOriginal.color,
                                                "time": subjectOriginal.time,
                                                "memo": subjectOriginal.memo,
                                                "term": DbDataCopy.CopyTerm(termOriginal: subjectOriginal.term!)])
        
        return subjectCopied
    }
}
