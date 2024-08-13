//
//  CalendarViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation
import Combine

enum CheckBoxMode {
    case done
    case proceed
}

final class CalendarViewModel: ObservableObject {
    @Published var months: [Month] = []
    @Published var clickedCurrentMonthDates: Date? {
        didSet {
            guard let date = clickedCurrentMonthDates else { return }
            months[selection].selectedDay = date
            searchCurrentDayIndex()
            fetchTodos()
        }
    }
    @Published var showTextField: Bool = false
    @Published var selection: Int {
        didSet {
            clickedCurrentMonthDates = months[selection].selectedDay
            getTodosCount()
        }
    }
    @Published var isPresent: Bool = false
    @Published var isTodoLoading: Bool = false
    
    @Published var detailTodo: Todo?
    
    enum Action {
        case pagingCalendar
        case clickCheckBox(_ todo: Todo, _ mode: CheckBoxMode)
        case deleteTodo(_ todo: Todo)
        case slideDeleteTodo(_ indexSet: IndexSet)
        case clickDetailBtn(_ todo: Todo)
        case updateTodo(_ todo: Todo)
        case createTodo(_ todo: Todo)
    }
    

    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    var currentDayIndex: Int?
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
    
    func send(action: Action) {
        switch action {
        case .pagingCalendar:
            pagingCalendar()
        case .clickCheckBox(let todo, let mode):
            clickCheckBox(todo, mode)
        case .deleteTodo(let todo):
            deleteTodo(todo)
        case .slideDeleteTodo(let indexSet):
            slideDeleteTodo(indexSet)
        case .clickDetailBtn(let todo):
            clickDetailBtn(todo)
        case .updateTodo(let todo):
            break
        case .createTodo(let todo):
            createTodo(todo)
        }
    }
}

extension CalendarViewModel {
    func currentTodos() -> [Todo] {
        if let index = currentDayIndex {
            return months[selection].days[index].todos
        } else {
            return []
        }
    }
    
    func currentTodosCount() -> Int {
        if let index = currentDayIndex {
            return months[selection].days[index].todosCount
        } else {
            return 0
        }
    }
    
    private func fetchMonths() {
        let calendar = Calendar.current
        let currentMonth = Date().startOfMonth
        
        for i in -6...6 {
            if let date = calendar.date(byAdding: .month, value: i, to: currentMonth) {
                months.append(date.createMonth(date))
            }
        }
        clickedCurrentMonthDates = months[selection].selectedDay
    }
    
    private func pagingCalendar() {
        let calendar = Calendar.current
        let currentMonth = months[selection].selectedDay.startOfMonth
        
        if selection == 3 {
            for i in -1 ... -3 {
                if let date = calendar.date(byAdding: .month, value: i, to: currentMonth) {
                    months.insert(date.createMonth(date), at: 0)
                }
            }
            for _ in 0..<3 {
                months.removeLast()
            }
            selection = 6
        } else if selection == 6 {
            for i in 1 ... 3 {
                if let date = calendar.date(byAdding: .month, value: i, to: currentMonth) {
                    months.append(date.createMonth(date))
                }
            }
            for _ in 0..<3 {
                months.removeFirst()
            }
        }
    }
    
    private func getTodosCount() {
        guard let year = clickedCurrentMonthDates?.format("YYYY"),
              let month = clickedCurrentMonthDates?.format("MM"),
              let monthIndex = months.firstIndex(where: { $0.selectedDay.format("MM") == month }),
              let index = searchStartDayIndex() else { return }
        
        container.services.todoService.getTodoCount(year: year, month: month)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] values in
                guard let self = self else { return }
                for value in values {
                    self.months[monthIndex].days[index + value.0 - 1].todosCount = value.1
                }
            }
            .store(in: &subscriptions)

    }
    
    private func fetchTodos() {
        if let index = months[selection].days.firstIndex(where: { $0.date == clickedCurrentMonthDates }),
           let date = clickedCurrentMonthDates?.format("YYYY-MM-dd") {
            if !months[selection].days[index].request {
                isTodoLoading = true
                container.services.todoService.getTodoList(date: date)
                    .sink { completion in
                        
                    } receiveValue: { [weak self] todos in
                        guard let self = self else { return }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                            self.months[self.selection].days[index].todos = todos
                            self.months[self.selection].days[index].request = true
                            self.isTodoLoading = false
                        }
                    }.store(in: &subscriptions)
            }
        }
    }
    
    private func clickCheckBox(_ todo: Todo, _ mode: CheckBoxMode) {
        if let dayIndex = currentDayIndex,
           let todoIndex = months[selection].days[dayIndex].todos.firstIndex(where: { $0.id == todo.id }),
           let todoId = months[selection].days[dayIndex].todos[todoIndex].todoListId {
            switch mode {
            case .done:
                months[selection].days[dayIndex].todos[todoIndex].status = .PROCEED
                months[selection].days[dayIndex].todosCount += 1
                container.services.todoService.reverseTodo(todoId: todoId)
                    .sink { completion in
                        
                    } receiveValue: { succeed in
                        
                    }.store(in: &subscriptions)

            case .proceed:
                months[selection].days[dayIndex].todos[todoIndex].status = .DONE
                months[selection].days[dayIndex].todosCount -= 1
                container.services.todoService.doneTodo(todoId: todoId)
                    .sink { completion in
                        
                    } receiveValue: { succeed in
                        
                    }.store(in: &subscriptions)
            }
        }
    }
    
    private func slideDeleteTodo(_ indexSet: IndexSet) {
        if let index = currentDayIndex,
           let todoIndex = indexSet.first,
           let todoId = months[selection].days[index].todos[todoIndex].todoListId {
            if months[selection].days[index].todos[todoIndex].status == .PROCEED {
                months[selection].days[index].todosCount -= 1
            }
            months[selection].days[index].todos.remove(atOffsets: indexSet)
            container.services.todoService.deleteTodo(todoId: todoId)
                .sink { completion in
                    
                } receiveValue: { succeed in
                    
                }.store(in: &subscriptions)
        }
    }
    
    private func deleteTodo(_ todo: Todo) {
        if let index = currentDayIndex,
           let todoIndex = months[selection].days[index].todos.firstIndex(where: { $0.id == todo.id }),
           let todoId = months[selection].days[index].todos[todoIndex].todoListId {
            months[selection].days[index].todos.remove(at: todoIndex)
            
            container.services.todoService.deleteTodo(todoId: todoId)
                .sink { completion in
                    
                } receiveValue: { succeed in
                    
                }.store(in: &subscriptions)
        }
    }
    
    private func createTodo(_ todo: Todo) {
        if let index = currentDayIndex {
            months[selection].days[index].todos.append(todo)
            months[selection].days[index].todosCount += 1
            showTextField = false
            container.services.todoService.createTodo(todo: todo)
                .sink { completion in
                    
                } receiveValue: { [weak self] id in
                    guard let self = self else { return }
                    guard let todoIndex = self.months[self.selection].days[index].todos.firstIndex(where: { $0.id == todo.id }) else { return }
                    self.months[self.selection].days[index].todos[todoIndex].todoListId = id
                }.store(in: &subscriptions)
        }
    }
    
    private func clickDetailBtn(_ todo: Todo) {
        detailTodo = todo
        isPresent = true
    }
    
    private func searchStartDayIndex() -> Int? {
        return months[selection].days.firstIndex(where: {$0.isCurrentMonthDay && $0.days == 1})
    }
    
    private func searchCurrentDayIndex() {
        currentDayIndex = months[selection].days.firstIndex(where: { $0.date == clickedCurrentMonthDates})
    }
    
    private func updateTodosCount(_ date: Date, _ count: Int) {
        if let index = months[selection].days.firstIndex(where: { $0.date == date} ) {
            months[selection].days[index].todosCount += count
        }
    }
}
