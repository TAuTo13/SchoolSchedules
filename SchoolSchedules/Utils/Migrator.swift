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
//        let config = Realm.Configuration(schemaVersion: 1)
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: {migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: SubjectItem.className()){ oldObject, newObject in
                    let id = oldObject!["_id"]! as! ObjectId
                    newObject!["id"] = id
                }
            }else if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: SubjectItem.className()){ oldObject, newObject in
                    let terms = oldObject!["term"]! as! LinkingObjects<Term>
                    let term = terms.first! as Term
                    let subSegment = term["subSegment"]
                    
                    newObject!["subSegment"] = subSegment
                }
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
