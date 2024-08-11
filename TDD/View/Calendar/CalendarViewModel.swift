//
//  CalendarViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    @Published var months: [Month] = []
    @Published var clickedCurrentMonthDates: Date? {
        didSet {
            months[selection].selectedDay = clickedCurrentMonthDates ?? Date()
        }
    }
    @Published var showTextField: Bool = false
    @Published var selection: Int {
        didSet {
            clickedCurrentMonthDates = months[selection].selectedDay
        }
    }
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    let dayOfWeek: [String] = Calendar.current.veryShortWeekdaySymbols
    
    init(clickedCurrentMonthDates: Date? = nil,
         container: DIContainer,
         selection: Int = 6) {
        self.clickedCurrentMonthDates = clickedCurrentMonthDates
        self.container = container
        self.selection = selection
        fetchMonths()
        getTodosCount()
    }
}

extension CalendarViewModel {
    private func fetchMonths() {
        let calendar = Calendar.current
        let currentMonth = Date().startOfMonth
        
        for i in -6...6 {
            if let date = calendar.date(byAdding: .month, value: i, to: currentMonth) {
                months.append(date.createMonth(date))
            }
        }
        selection = 6
        clickedCurrentMonthDates = months[selection].selectedDay
    }
    
    private func getTodosCount() {
        guard let year = clickedCurrentMonthDates?.format("YYYY"),
              let month = clickedCurrentMonthDates?.format("MM") else { return }
        
        guard let index = searchStartDayIndex() else { return }
        
        container.services.todoService.getTodoCount(year: year, month: month)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] values in
                guard let self = self else { return }
                for value in values {
                    self.months[self.selection].days[index + value.0 - 1].todosCount = value.1
                }
            }
            .store(in: &subscriptions)

    }
    
    private func searchStartDayIndex() -> Int? {
        return months[selection].days.firstIndex(where: {$0.isCurrentMonthDay && $0.days == 1})
    }
}
