//
//  CalendarViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation
import Combine

final class CalendarViewModel: ObservableObject {
    @Published var months: [Month]
    @Published var selection: Int
    @Published var showTextField: Bool = false
    @Published var title: String = ""
    @Published var memo: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    let dayOfWeek: [String] = Calendar.current.veryShortWeekdaySymbols
        
    init(months: [Month] = [],
         selection: Int = 12) {
        self.months = months
        self.selection = selection
        self.fetchMonths()
    }

}

extension CalendarViewModel {
    func fetchMonths() {
        let calendar = Calendar.current
        let currentMonth = Date().startOfMonth
        
        for offset in -12...12 {
            if let date = calendar.date(byAdding: .month, value: offset, to: currentMonth) {
                months.append(date.createMonth(date))
            }
        }
        months[selection].days[20].todos = [.init(todoListId: 1, content: "dk", memo: "dk", tag: "kd"),.init(todoListId: 1, content: "dk", memo: "dk", tag: "kd"),.init(todoListId: 1, content: "dk", memo: "dk", tag: "kd")]
        selection = 12
    }
    
    func paginateMonth() {
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
    }
    
    func createTodo() {
        let request = CreateTodoRequest(content: title, memo: memo, tag: "아", deadline: months[selection].selectedDay.date.format("yyyy-MM-dd"))
        TodoAPI.createTodo(request: request)
            .sink { completion in
                self.showTextField = false
            } receiveValue: { out in
                self.showTextField = false
                print(out)
            }
            .store(in: &subscriptions)

    }
}
