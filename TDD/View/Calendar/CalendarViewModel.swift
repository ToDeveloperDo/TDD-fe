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
    @Published var selection: Int {
        didSet {
            slideSelectedDay()
            send(action: .fetchTodos)
            send(action: .fetchTodosCount)
        }
    }
    @Published var showTextField: Bool = false
    @Published var title: String = ""
    @Published var memo: String = ""
    @Published var selectedDay: Day? 
    @Published var isPresent: Bool = false
    @Published var detailTodo: Todo?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    let dayOfWeek: [String] = Calendar.current.veryShortWeekdaySymbols
    
    init(container: DIContainer, selection: Int = 6) {
        self.container = container
        self.selection = selection
        self.fetchMonths()
    }
    
    enum Action {
        case fetchTodos
        case fetchTodosCount
        case updateSelectedDay
        case paginate
        case createTodo(todo: Todo)
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
        case .updateSelectedDay:
            updateSelectedDay()
        case .paginate:
            paginateMonth()
        case .createTodo(let todo):
            createTodo(todo)
        case .selectDay(let day):
            selectDay(day)
        case .moveTodo(let todo, let mode):
            moveTodo(todo, mode)
        case .deleteTodo(let index):
            deleteTodo(index)
        case .moveDetail(let todo):
            moveDetail(todo)
            
        }
    }
}

extension CalendarViewModel {
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
    
    private func updateSelectedDay() {        
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func fetchMonths() {
        let calendar = Calendar.current
        let currentMonth = Date().startOfMonth
        
        for offset in -6...6 {
            if let date = calendar.date(byAdding: .month, value: offset, to: currentMonth) {
                months.append(date.createMonth(date))
            }
        }

        selection = 6
        
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
        send(action: .fetchTodos)
    }
    
    private func fetchTodos() {
        if ((selectedDay?.todos.isEmpty) != nil) {
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
    }
    
    private func fetchTodosCount() {
        guard let selectedDay = selectedDay else {return}
        let index = months[selection].days.firstIndex(where: { $0.days != -1 })!
        let year = selectedDay.date.format("YYYY")
        let month = selectedDay.date.format("MM")
        print("fetchTodoCount Called!")
        container.services.todoService.getTodoCount(year: year, month: month)
            .sink { completion in
                if case .failure = completion {
                    return
                }
            } receiveValue: { [weak self] values in
                guard let self = self else { return }
                for value in values {
                    self.months[self.selection].days[index+value.0-1].todosCount = value.1
                    self.selectedDay = self.months[self.selection].days[self.months[self.selection].selectedDayIndex]
                }
            }
            .store(in: &subscriptions)
    }
        
    private func createTodo(_ todo: Todo) {
        months[selection].days[months[selection].selectedDayIndex].todos.append(todo)
        months[selection].days[months[selection].selectedDayIndex].todosCount += 1
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
        showTextField = false
        let request = CreateTodoRequest(content: todo.content,
                                        memo: todo.memo,
                                        tag: todo.tag,
                                        deadline: todo.deadline)
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
    
    
    // 날짜 클릭 시 선택된 날짜 교체
    private func selectDay(_ selectDay: Day) {
        let selectDayIndex = months[selection].days.firstIndex { $0.date == selectDay.date }
        months[selection].selectedDayIndex = selectDayIndex ?? -1
        selectedDay = selectDay
    }
    
    // 슬라이드 시 선택된 날짜 교체
    private func slideSelectedDay() {
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func searchTodoIndex(_ todo: Todo) -> Int {
        let index = months[selection].days[months[selection].selectedDayIndex].todos.firstIndex { $0 == todo }
        guard let index else { return -1 }
        return index
    }
    
    private func moveDetail(_ todo: Todo) {
        
    }
}
