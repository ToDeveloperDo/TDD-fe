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
    @Published var selection: Int = 12
    @Published var showTextField: Bool = false
    @Published var title: String = ""
    @Published var memo: String = ""
    @Published var selectedDay: Day?
    
    private var subscriptions = Set<AnyCancellable>()
    
    let dayOfWeek: [String] = Calendar.current.veryShortWeekdaySymbols
    
    init() {        
        self.fetchMonths()
    }
    
    enum Action {
        case paginate
        case createTodo
        case selectDay(day: Day)
    }
    
    func send(action: Action) {
        switch action {
        case .paginate:
            paginateMonth()
        case .createTodo:
            createTodo()
        case .selectDay(let day):
            selectDay(selectDay: day)
        }
    }
}

extension CalendarViewModel {
    private func fetchMonths() {
        let calendar = Calendar.current
        let currentMonth = Date().startOfMonth
        
        for offset in -12...12 {
            if let date = calendar.date(byAdding: .month, value: offset, to: currentMonth) {
                months.append(date.createMonth(date))
            }
        }
        months[selection].days[22].todos = [
                   .init(todoListId: 1, content: "dk", memo: "dk", tag: "kd"),
                   .init(todoListId: 1, content: "dk", memo: "dk", tag: "kd"),
                   .init(todoListId: 1, content: "dk", memo: "dk", tag: "kd")
               ]
        selection = 12
        
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func paginateMonth() {
        let calendar = Calendar.current
        let currentMonthIndex = selection
        
        if currentMonthIndex == 0 {
            if let firstMonthDate = months.first?.days.first?.date {
                let newMonthDate = calendar.date(byAdding: .month, value: -1, to: firstMonthDate.startOfMonth)!
                months.insert(newMonthDate.createMonth(newMonthDate), at: 0)
                months.removeLast()
                selection = 1
            }
        }
        
        if currentMonthIndex == months.count - 1 {
            if let lastMonthDate = months.last?.days.first?.date {
                let newMonthDate = calendar.date(byAdding: .month, value: 1, to: lastMonthDate.startOfMonth)!
                months.append(newMonthDate.createMonth(newMonthDate))
                months.removeFirst()
                selection = months.count - 2
            }
        }
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func createTodo() {
        let request = CreateTodoRequest(content: title, memo: memo, tag: "아", deadline: selectedDay?.date.format("yyyy-MM-dd") ?? "")
        TodoAPI.createTodo(request: request)
            .sink { completion in
                self.showTextField = false
            } receiveValue: { out in
                self.showTextField = false
                print(out)
            }
            .store(in: &subscriptions)
    }
    
    private func selectDay(selectDay: Day) {
        let selectedDay = months[selection].days.first { $0.date == selectDay.date }
        let selectDayIndex = months[selection].days.firstIndex { $0.date == selectDay.date }
        months[selection].selectedDayIndex = selectDayIndex ?? -1
        self.selectedDay = selectDay
    }
}
