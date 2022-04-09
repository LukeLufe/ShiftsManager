//
//  Date+Expansion.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/2.
//

import Foundation

extension Date {
    
    static func confirmToday(date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-M-d"
        let today = formatter.string(from: Date())
        let parameterDate = formatter.string(from: date)
        return today == parameterDate
    }
    
    static func dayOfMonth(year: Int , month: Int) -> (monthRange: Int, weekday: Int) {
        let dateComponents = DateComponents(year: year , month: month)
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        let weekday = Calendar.current.component(.weekday, from: date)
        return (range?.count ?? 0, weekday - 1)
    }
    
    static func date(FromComponents year: Int, month: Int, day: Int) -> Date {
        let dateComponents = DateComponents(timeZone: TimeZone(identifier: "Asia/Taipei"), year: year, month: month, day: day)
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static func date(FromComponents hour: Int, minute: Int) -> Date {
        let dateComponents = DateComponents(timeZone: TimeZone(identifier: "Asia/Taipei"), hour: hour, minute: minute)
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-M-d"
        return formatter.string(from: self)
    }
    
    func toDayString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func toOClock() -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "HH:mm"
        let dateArray = formatter.string(from: self).split(separator: ":").map {
            String($0)
        }
        let finalDateStr = "\(dateArray.first ?? "00"):00"
        return formatter.date(from: finalDateStr) ?? Date()
    }
    
    func toHalfClock() -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "HH:mm"
        let dateArray = formatter.string(from: self).split(separator: ":").map {
            String($0)
        }
        let finalDateStr = "\(dateArray.first ?? "00"):30"
        return formatter.date(from: finalDateStr) ?? Date()
    }
    
}
