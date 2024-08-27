//
//  DateExtensions.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import Foundation

extension Date {
    func toAmPmTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            let now = Date()
            let hourDifference = calendar.component(.hour, from: self) == calendar.component(.hour, from: now)
            if hourDifference {
                return "지금"
            }
        }
        
        return formatter.string(from: self)
    }
}

extension Date {
    func toDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "오늘"
        }
        dateFormatter.dateFormat = "E" 
        return dateFormatter.string(from: self)
    }
}
