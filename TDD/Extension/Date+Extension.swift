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
    
    var startOfWeeks: CGFloat {
        guard let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: self) else { return 0 }
        
        return CGFloat(range.count)
    }
    
    var numberOfWeeks: CGFloat {
        guard let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: self) else { return 0 }
        
        return CGFloat(range.count)
    }
    
    func createMonth(_ date: Date = Date()) -> [Month] {
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }
        
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else { return [] }
        
        var days = range.compactMap { day -> Month in
            let date = calendar.date(byAdding: .day, value: day-1, to: startDate)!
            return Month(day: calendar.component(.day, from: date), date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<(firstWeekday - calendar.firstWeekday) {
            days.insert(Month(day: -1, date: date), at: 0)
        }
        
        return days
    }
    
    func createPreviousMonth() -> [Month] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? Date()
        
        guard let startDate = calendar.date(byAdding: .month, value: -1, to: startOfMonth) else { return [] }
        
        return createMonth(startDate)
    }
    
    func createNextMonth() -> [Month] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? Date()
        
        guard let startDate = calendar.date(byAdding: .month, value: +1, to: startOfMonth) else { return [] }
        
        return createMonth(startDate)
    }
}
