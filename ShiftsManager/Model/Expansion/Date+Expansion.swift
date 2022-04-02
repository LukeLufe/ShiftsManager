//
//  Date+Expansion.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/2.
//

import Foundation

extension Date {
    
    static func confirmToday(year: Int, month: Int, day: Int) -> Bool {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-M-d"
        let today = formatter.string(from: Date())
        let parameterDate = "\(year)-\(month)-\(day)"
        return today == parameterDate
    }
    
    static func dayOfMonth(year: Int , month: Int) -> (monthRange: Int, weekday: Int) {
        let dateComponents = DateComponents(year: year , month: month)
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        let weekday = Calendar.current.component(.weekday, from: date)
        return (range?.count ?? 0, weekday - 1)
    }
    
}
