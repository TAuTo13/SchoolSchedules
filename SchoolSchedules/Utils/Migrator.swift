//
//  Migrator.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/09.
//

import Foundation
import RealmSwift

class Migrator {
    init() {
        updateSchema()
    }
    
    func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 1)
//        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: {migration, oldSchemaVersion in
//            if oldSchemaVersion < 2 {
//                migration.enumerateObjects(ofType: SubjectItem.className()){ oldObject, newObject in
//                    let term = oldObject!["term"]! as! Term
//                    newObject!["termId"] = term.id
//                }
//
//                migration.enumerateObjects(ofType: ScheduleItem.className()) { oldObject, newObject in
//                    let subject = oldObject!["subjectItem"]! as! SubjectItem
//                    let term = oldObject!["term"]! as! Term
//                    newObject!["subjectId"] = subject.id
//                    newObject!["termId"] = term.id
//                }
//            }
//        })
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
