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
    
}
