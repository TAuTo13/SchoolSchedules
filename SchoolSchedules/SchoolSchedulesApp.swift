//
//  SchoolSchedulesApp.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/01/18.
//

import SwiftUI
import RealmSwift

@main
struct SchoolSchedulesApp: SwiftUI.App {
    let migrator = Migrator()
    
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
            let realm = try! Realm()
            ContentView()
                .environment(\.realm, realm)
        }
    }
}
