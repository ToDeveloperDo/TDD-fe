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
    @Published var isPresent: Bool = false
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    let dayOfWeek: [String] = Calendar.current.veryShortWeekdaySymbols
    
    init(container: DIContainer) {
        self.container = container
        self.fetchMonths()
//        self.fetchTodos()
    }
    
    enum Action {
        case fetchTodos
        case fetchTodosCount
        case paginate
        case createTodo
        case selectDay(day: Day)
        case moveTodo(todo: Todo, mode: Mode)
        case deleteTodo(index: IndexSet)
        case moveDetail(todo: Todo)
    }
    
    enum Mode {
        case finish
        case reverse
    }
    
    func send(action: Action) {
        switch action {
        case .fetchTodos:
            fetchTodos()
        case .fetchTodosCount:
            fetchTodosCount()
        case .paginate:
            paginateMonth()
        case .createTodo:
            createTodo()
        case .selectDay(let day):
            selectDay(day)
        case .moveTodo(let todo, let mode):
            moveTodo(todo, mode)
        case .deleteTodo(let index):
            deleteTodo(index)
        case .moveDetail(let todo):
            break
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

        selection = 12
        
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func fetchTodos() {
        guard let date = selectedDay?.date.format("YYYY-MM-dd") else { return }
        container.services.todoService.getTodoList(date: date)
            .sink { completion in
                if case .failure = completion {
                    return
                }
            } receiveValue: { [weak self] todos in
                guard let self = self else { return }
                self.months[self.selection].days[self.months[self.selection].selectedDayIndex].todos = todos
                self.selectedDay = self.months[self.selection].days[self.months[self.selection].selectedDayIndex]
            }.store(in: &subscriptions)
    }
    
    private func fetchTodosCount() {
        guard let selectedDay = selectedDay else {return}
        let year = selectedDay.date.format("YYYY")
        let month = selectedDay.date.format("MM")
        container.services.todoService.getTodoCount(year: year, month: month)
            .sink { completion in
                if case .failure = completion {
                    return
                }
            } receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.months[self.selection].days.map { day in
                    
                }
            }

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
        let todo: Todo = .init(todoListId: 1, content: title, memo: memo, tag: "코", status: .PROCEED)
        months[selection].days[months[selection].selectedDayIndex].todos.append(todo)
        months[selection].days[months[selection].selectedDayIndex].todosCount += 1
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
        showTextField = false
//        let request = CreateTodoRequest(content: title, memo: memo, tag: "아", deadline: selectedDay?.date.format("yyyy-MM-dd") ?? "")
//        TodoAPI.createTodo(request: request)
//            .sink { completion in
//                self.showTextField = false
//            } receiveValue: { out in
//                self.showTextField = false
//                print(out)
//            }
//            .store(in: &subscriptions)
    }
    
    private func moveTodo(_ todo: Todo, _ mode: Mode) {
        let todoIndex = searchTodoIndex(todo)
        
            switch mode {
            case .finish:
                // TODO: - Todo 완료 API 호출
                months[selection].days[months[selection].selectedDayIndex].todosCount -= 1
                months[selection].days[months[selection].selectedDayIndex].todos[todoIndex].status = .DONE
            case .reverse:
                // TODO: - Todo 번복 API 호출
                months[selection].days[months[selection].selectedDayIndex].todosCount += 1
                months[selection].days[months[selection].selectedDayIndex].todos[todoIndex].status = .PROCEED
            }
        
            selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func deleteTodo(_ index: IndexSet) {
        // TODO: - Todo 삭제 API 호출
        months[selection].days[months[selection].selectedDayIndex].todosCount -= 1
        months[selection].days[months[selection].selectedDayIndex].todos.remove(atOffsets: index)
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func selectDay(_ selectDay: Day) {
        let selectDayIndex = months[selection].days.firstIndex { $0.date == selectDay.date }
        months[selection].selectedDayIndex = selectDayIndex ?? -1
        selectedDay = selectDay
    }
    
    private func searchTodoIndex(_ todo: Todo) -> Int {
        let index = months[selection].days[months[selection].selectedDayIndex].todos.firstIndex { $0 == todo }
        guard let index else { return -1 }
        return index
    }
}
