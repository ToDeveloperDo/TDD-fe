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
        self.fetchTodos()
    }
    
    enum Action {
        case fetchTodos
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
        months[selection].days[24].todos = [
                   .init(todoListId: 1, content: "가", memo: "가", tag: "kd", status: .PROCEED),
                   .init(todoListId: 1, content: "니", memo: "나", tag: "kd", status: .PROCEED),
                   .init(todoListId: 1, content: "다", memo: "다", tag: "kd", status: .PROCEED),
                   .init(todoListId: 1, content: "라", memo: "다", tag: "kd", status: .PROCEED),
                   
               ]
        selection = 12
        
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func fetchTodos() {
        let proceedTodo = months[selection].days[months[selection].selectedDayIndex].todos.filter { $0.status == .PROCEED }
        months[selection].days[months[selection].selectedDayIndex].todosCount = proceedTodo.count
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
