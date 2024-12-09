//
//  Date+Extension.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation

extension Date {
    // format에 따라 Date를 String으로 변환 후 리턴
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func isSameDay(_ date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        let calendar = Calendar.current
        
        return calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? Date()
    }
    
    var startOfYear: Date {
        let calendar = Calendar.current
        
        return calendar.date(from: calendar.dateComponents([.year], from: self)) ?? Date()
    }
    
    var startOfWeeks: CGFloat {
        guard let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: self) else { return 0 }
        
        return CGFloat(range.count)
    }
    
    var numberOfWeeks: CGFloat {
        guard let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: self) else { return 0 }
        
        return CGFloat(range.count)
    }
    
    func createMonth(_ date: Date = Date()) -> Month {
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return Month(days: [], selectedDay: Date())
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return Month(days: [], selectedDay: Date())
        }
        
        var days = range.compactMap { day -> Day in
            let date = calendar.date(byAdding: .day, value: day-1, to: startDate)!
            return Day(days: calendar.component(.day, from: date), date: date)
        }
        
        let currentDate = Date()
        
        let currentStartOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        // Add previous month's days to the beginning
        if let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: startDate),
           let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonthDate) {
            let previousMonthDays = Array(previousMonthRange)
            for i in stride(from: offset - 1, through: 0, by: -1) {
                let day = previousMonthDays[previousMonthDays.count - offset + i]
                if let date = calendar.date(byAdding: .day, value: day - 1 - (previousMonthDays.count - offset), to: previousMonthDate) {
                    days.insert(Day(days: day, date: date, isCurrentMonthDay: false), at: 0)
                }
            }
        }
        
        // Add next month's days to the end
        if let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: startDate),
           let nextMonthRange = calendar.range(of: .day, in: .month, for: nextMonthDate) {
            let nextMonthDays = Array(nextMonthRange)
            let remainingDays = 42 - days.count
            for i in 0..<remainingDays {
                let day = nextMonthDays[i]
                if let date = calendar.date(byAdding: .day, value: day - 1, to: nextMonthDate) {
                    days.append(Day(days: day, date: date, isCurrentMonthDay: false))
                }
            }
        }
        
        var selectedDay: Date?
        
        if currentStartOfMonth == startDate {
            selectedDay = days.first(where: { $0.date.isToday })?.date
        } else {
            selectedDay = days.first(where: { $0.isCurrentMonthDay })?.date
        }
        
        return Month(days: days, selectedDay: selectedDay ?? Date())
    }
}
