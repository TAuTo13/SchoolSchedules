//
//  ErrorMessage.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/19.
//

import Foundation

struct ErrorMessage: Identifiable {
    let id = UUID()
    
    var title: String
    var message: String
}
