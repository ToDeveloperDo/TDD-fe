//
//  CalendarViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation

final class CalendarViewModel: ObservableObject {
    @Published var selectedDay: Month?
    @Published var months: [[Month]] = [[], [], []]
    @Published var selection: Int = 1
    
    let dayOfWeek: [String] = Calendar.current.veryShortWeekdaySymbols
    
    func fetchMonths() {
        months[0] = Date().createPreviousMonth()
        months[1] = Date().createMonth()
        months[2] = Date().createNextMonth()
        selectedDay = months[1].filter { $0.date == Calendar.current.startOfDay(for: Date()) }.first!
            
    }
    
    func paginateMonth() {
        guard let date = months[selection].first?.date else { return }
        
        if selection == 0 {
            months.insert(date.createPreviousMonth(), at: 0)
            months.removeLast()
            selection = 1
        }
        
        if selection == 2 {
            months.append(date.createNextMonth())
            months.removeFirst()
            selection = 1
        }
    }
}
