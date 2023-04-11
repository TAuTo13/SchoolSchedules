//
//  DbStore.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/03/14.
//

import Foundation
import RealmSwift

class DbStore: ObservableObject {
    private(set) var SubjectEntities: Results<SubjectItem>
    private(set) var ScheduleEntities: Results<ScheduleItem>
    private(set) var TermEntities: Results<Term>
    
    private var notificationTokens: [NotificationToken] = []
    
    private var realm: Realm
    
    init(){
        try! realm = Realm()
        
        SubjectEntities = realm.objects(SubjectItem.self)
        ScheduleEntities = realm.objects(ScheduleItem.self)
        TermEntities = realm.objects(Term.self)
        
        notificationTokens.append(SubjectEntities.observe{ _ in
            self.objectWillChange.send()
        })
        
        notificationTokens.append(ScheduleEntities.observe{ _ in
            self.objectWillChange.send()
        })
        
        notificationTokens.append(TermEntities.observe{ _ in
            self.objectWillChange.send()
        })
    }
    
    func addSchedule(schedule: ScheduleItem, subject: SubjectItem) throws {
        do {
            try realm.write {
                realm.add(schedule)
                subject.schedules.append(schedule)
            }
        } catch {
            throw error
        }
    }
    
    func addSubject(subject: SubjectItem, term: Term) throws {
        if checkSubjectCollisioning(weekday: subject.weekday, time: subject.time, subSegment: subject.subSegment, term: term) {
            throw DbException.CollisioningException("The subject is collisioning with the other subject.")
        }
        
        let oldTerm = TermEntities.where {
            $0.id == term.id
        }.first!
        
        do {
            try realm.write {
                realm.add(subject)
                oldTerm.subjects.append(subject)
            }
        } catch {
            throw error
        }
    }
    
    func addTerm(_ term: Term) throws {
        if checkTermCollisioning(term) {
            throw DbException.CollisioningException("The term is collisioning with the other term.")
        }
        
        do {
            try realm.write {
                realm.add(term)
            }
        } catch {
            throw error
        }
    }
    
    func updateSchedule(_ schedule: ScheduleItem) throws {
        let oldSchedule = ScheduleEntities.where{
            $0.id == schedule.id
        }.first
        
        if let oldSchedule = oldSchedule{
            if checkScheduleCollisioning(oldSchedule: oldSchedule, newSchedule: schedule) {
                throw DbException.CollisioningException("The schedule is collisioning with the other schedule")
            }
            
            do {
                try realm.write {
                    oldSchedule.date = schedule.date
                    oldSchedule.room = schedule.room
                    oldSchedule.time = schedule.time
                }
            } catch {
                throw error
            }
        }
    }
    
    func updateTerm(_ term: Term) throws {
        if term.subjects.count != 0 {
            throw DbException.TermModifyLockException("The term has subjects, can't be modified.")
        }
        
        if checkTermCollisioning(term) {
            throw DbException.CollisioningException("The term is collisioning with the other term.")
        }
        
        let oldTerm = TermEntities.where{
            $0.id == term.id
        }.first
        
        if let oldTerm = oldTerm {
            do {
                try realm.write {
                    oldTerm.year = term.year
                    oldTerm.segment = term.segment
                }
            } catch {
                throw error
            }
        }
    }
    
    func deleteSubject(_ subject: SubjectItem) throws {
        let schedules = ScheduleEntities.where{$0.subjectItem.id == subject.id}
        do {
            try schedules.forEach{ schedule in
                try deleteSchedule(schedule)
            }
        } catch {
            throw error
        }
        
        let subject = SubjectEntities.where{
            $0.id == subject.id
        }
        
        do {
            try realm.write{
                realm.delete(subject)
            }
        } catch {
            throw error
        }
    }
    
    func deleteSchedule(_ schedule: ScheduleItem) throws {
        let schedule = ScheduleEntities.where{
            $0.id == schedule.id
        }
        
        do {
            try realm.write{
                realm.delete(schedule)
            }
        } catch {
            throw error
        }
    }
    
    func deleteTerm(_ term:Term) throws {
        if term.subjects.count != 0 {
            throw DbException.TermModifyLockException("The term has subjects can't be modified")
        }
        
        let term = TermEntities.where{
            $0.id == term.id
        }
        
        do {
            try realm.write{
                realm.delete(term)
            }
        } catch {
            throw error
        }
    }
    
    func checkScheduleCollisioning(oldSchedule: ScheduleItem, newSchedule: ScheduleItem) -> Bool {
        if oldSchedule.time != newSchedule.time ||
            oldSchedule.date != newSchedule.date {
            let schedules = ScheduleEntities.where{$0.date == newSchedule.date && $0.time == newSchedule.time}
            return schedules.count != 0
        }
        
        return false
    }
    
    func checkSubjectCollisioning(weekday: Int, time: Int, subSegment: String, term: Term) -> Bool {
        let subjects = SubjectEntities.where({
            $0.term.year == term.year &&
            $0.term.segment == term.segment
        })
        
        return subjects.where({
            $0.weekday == weekday && $0.time == time && $0.subSegment == subSegment
        }).count != 0
    }
    
    func checkTermCollisioning(_ term: Term) -> Bool {
        let terms = TermEntities.where{
            $0.year == term.year &&
            $0.segment == term.segment
        }
        
        return terms.count != 0
    }
    
    deinit{
        notificationTokens.forEach{$0.invalidate()}
    }
    
}
