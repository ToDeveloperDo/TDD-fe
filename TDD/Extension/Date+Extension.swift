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
            return Month(month: "", days: [], selectedDayIndex: -1)
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else { 
            return Month(month: "", days: [], selectedDayIndex: -1)
        }
        
        var days = range.compactMap { day -> Day in
            let date = calendar.date(byAdding: .day, value: day-1, to: startDate)!
            return Day(days: calendar.component(.day, from: date), date: date)
        }
        
        let currentDate = Date()
        let month = startDate.format("YYYY-MM")
        let currentStartOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
        
        var selectedDay: Int
                                
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        for _ in 0..<offset {
            days.insert(Day(days: -1, date: startDate), at: 0)
        }
        
        if currentStartOfMonth == startDate {
            selectedDay = days.firstIndex(where: { $0.date.isToday && $0.days != -1 }) ?? -1
        } else {
            selectedDay = days.firstIndex(where: { $0.days != -1 }) ?? -1
        }
        
        return Month(month: month, days: days, selectedDayIndex: selectedDay)
    }
}
