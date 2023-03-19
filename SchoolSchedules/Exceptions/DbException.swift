//
//  DbException.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/18.
//

import Foundation

enum DbException: Error {
    case CollisioningException(String)
    case TermModifyLockException(String)
}

extension DbException: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .CollisioningException:
            return "Object collisioning occured. Failed to update the object."
        case .TermModifyLockException:
            return "The Term object can't be modified."
        }
    }
}
