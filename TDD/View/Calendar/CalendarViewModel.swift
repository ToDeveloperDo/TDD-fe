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
        case updateTodo(todo: Todo)
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
        case .updateTodo(let todo):
            updateTodo(todo)
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
        
        container.services.todoService.createTodo(todo: todo)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("CreateTodo: Error(\(error))")
                    // TODO: Todo upload 실패
                }
            } receiveValue: { [weak self] id in
                guard let self = self else { return }
                guard let index = self.months[self.selection].days[self.months[self.selection].selectedDayIndex].todos.firstIndex(where: { $0.id == todo.id }) else { return }
                self.months[self.selection].days[self.months[self.selection].selectedDayIndex].todos[index].todoListId = id
            }
            .store(in: &subscriptions)
    }
    
    private func moveTodo(_ todo: Todo, _ mode: Mode) {
        let todoIndex = searchTodoIndex(todo.id)
        
            switch mode {
            case .finish:
                // TODO: - Todo 완료 API 호출
                months[selection].days[months[selection].selectedDayIndex].todosCount -= 1
                months[selection].days[months[selection].selectedDayIndex].todos[todoIndex].status = .DONE
                guard let id = months[selection].days[months[selection].selectedDayIndex].todos[todoIndex].todoListId else { return }
                container.services.todoService.doneTodo(todoId: id)
                    .sink { completion in
                        print("\(completion)")
                    } receiveValue: { succeed in
                        print("\(succeed)")
                    }
                    .store(in: &subscriptions)

            case .reverse:
                // TODO: - Todo 번복 API 호출
                months[selection].days[months[selection].selectedDayIndex].todosCount += 1
                months[selection].days[months[selection].selectedDayIndex].todos[todoIndex].status = .PROCEED
                guard let id = months[selection].days[months[selection].selectedDayIndex].todos[todoIndex].todoListId else { return }
                container.services.todoService.reverseTodo(todoId: id)
                    .sink { completion in
                        print("\(completion)")
                    } receiveValue: { succeed in
                        print("\(succeed)")
                    }
                    .store(in: &subscriptions)
            }
        
            selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
    
    private func deleteTodo(_ index: IndexSet) {
        // TODO: - Todo 삭제 API 호출
        guard let firstIndex = index.first else { return }
        
        let todoId = months[selection].days[months[selection].selectedDayIndex].todos[firstIndex].todoListId
        guard let todoId = todoId else { return }
        
        months[selection].days[months[selection].selectedDayIndex].todosCount -= 1
        months[selection].days[months[selection].selectedDayIndex].todos.remove(atOffsets: index)
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
                
        container.services.todoService.deleteTodo(todoId: todoId)
            .sink { completion in
                print("\(completion)")
            } receiveValue: { succeed in
                print("\(succeed)")
            }
            .store(in: &subscriptions)

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
    
    private func searchTodoIndex(_ todo: String) -> Int {
        let index = months[selection].days[months[selection].selectedDayIndex].todos.firstIndex { $0.id == todo }
        guard let index else { return -1 }
        return index
    }
    
    private func searchMonthIndex(_ monthString: String) -> Int {
        let index = months.firstIndex(where: { $0.month == monthString })
        guard let index else { return -1 }
        return index
    }
    
    private func updateTodo(_ todo: Todo) {
        let todoIndex = searchTodoIndex(todo.id)
        let base = months[selection].days[months[selection].selectedDayIndex].todos[todoIndex]
        
        
        if base.deadline != todo.deadline {
            let todoString = todo.deadline.split(separator: "-")
            let monthString = String(todoString[0] + "-" + todoString[1])
            let monthIndex = searchMonthIndex(monthString)
            let dayIndex = months[monthIndex].days.firstIndex(where: { $0.days == Int(todoString[2]) }) ?? -1
            
            months[selection].days[months[selection].selectedDayIndex].todos.remove(at: todoIndex)
            
            if base.status == .PROCEED {
                months[selection].days[months[selection].selectedDayIndex].todosCount -= 1
                months[monthIndex].days[dayIndex].todosCount += 1
            }
            months[monthIndex].days[dayIndex].todos.append(todo)
            
        } else {
            if base.status != todo.status {
                if todo.status == .PROCEED {
                    months[selection].days[months[selection].selectedDayIndex].todosCount += 1
                } else {
                    months[selection].days[months[selection].selectedDayIndex].todosCount -= 1
                }
            }
            months[selection].days[months[selection].selectedDayIndex].todos[todoIndex] = todo
        }
        
        container.services.todoService.editTodo(todo: todo)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("UpdateTodo Error(\(error))")
                }
            } receiveValue: { succeed in
                if succeed {
                    
                }
            }
            .store(in: &subscriptions)

        
        selectedDay = months[selection].days[months[selection].selectedDayIndex]
    }
}
