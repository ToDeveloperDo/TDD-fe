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
            pagingCalendar()
            isSlidingLoading = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.isSlidingLoading = false
            }
        }
    }
    @Published var isSlidingLoading = false
    @Published var isPresent: Bool = false
    @Published var isTodoLoading: Bool = false
    @Published var isError: Bool = false
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
            updateTodo(todo)
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
        let threshold = 3
                
        if selection < threshold {
            if let firstMonth = months.first,
               let newMonth = calendar.date(byAdding: .month, value: -1, to: firstMonth.selectedDay) {
                months.insert(newMonth.createMonth(newMonth), at: 0)
                months.removeLast()
                selection += 1
            }
        }
        
        if selection > months.count - threshold - 1 {
            if let lastMonth = months.last,
               let newMonth = calendar.date(byAdding: .month, value: 1, to: lastMonth.selectedDay) {
                months.append(newMonth.createMonth(newMonth))
                months.removeFirst()
                selection -= 1 
            }
        }
    }
    
    func getTodosCount() {
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
    
    func onappearFetchTodo() {
        if let index = months[selection].days.firstIndex(where: { $0.date == clickedCurrentMonthDates }),
           let date = clickedCurrentMonthDates?.format("YYYY-MM-dd") {
            isTodoLoading = true
            container.services.todoService.getTodoList(date: date)
                .sink { [weak self] completion in
                    if case .failure(_) = completion {
                        self?.isTodoLoading = false
                    }
                } receiveValue: { [weak self] todos in
                    guard let self = self else { return }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.months[self.selection].days[index].todos = todos
                        self.months[self.selection].days[index].request = true
                        self.isTodoLoading = false
                    }
                }.store(in: &subscriptions)
        }
    }
    
    private func fetchTodos() {
        if let index = months[selection].days.firstIndex(where: { $0.date == clickedCurrentMonthDates }),
           let date = clickedCurrentMonthDates?.format("YYYY-MM-dd") {
            if !months[selection].days[index].request {
                isTodoLoading = true
                container.services.todoService.getTodoList(date: date)
                    .sink { [weak self] completion in
                        if case .failure(_) = completion {
                            self?.isTodoLoading = false
                        }
                    } receiveValue: { [weak self] todos in
                        guard let self = self else { return }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
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
            let currentSelection = selection
            switch mode {
            case .done:
                months[currentSelection].days[dayIndex].todos[todoIndex].status = .PROCEED
                months[currentSelection].days[dayIndex].todosCount += 1
                container.services.todoService.reverseTodo(todoId: todoId)
                    .sink { [weak self] completion in
                        if case .failure(_) = completion {
                            self?.isError = true
                            self?.months[currentSelection].days[dayIndex].todos[todoIndex].status = .DONE
                            self?.months[currentSelection].days[dayIndex].todosCount -= 1
                        }
                    } receiveValue: { _ in
                        
                    }.store(in: &subscriptions)

            case .proceed:
                months[currentSelection].days[dayIndex].todos[todoIndex].status = .DONE
                months[currentSelection].days[dayIndex].todosCount -= 1
                container.services.todoService.doneTodo(todoId: todoId)
                    .sink { [weak self] completion in
                        if case .failure(_) = completion {
                            self?.isError = true
                            self?.months[currentSelection].days[dayIndex].todos[todoIndex].status = .PROCEED
                            self?.months[currentSelection].days[dayIndex].todosCount += 1
                        }
                    } receiveValue: { succeed in
                        
                    }.store(in: &subscriptions)
            }
        }
    }
    
    private func slideDeleteTodo(_ indexSet: IndexSet) {
        if let index = currentDayIndex,
           let todoIndex = indexSet.first,
           let todoId = months[selection].days[index].todos[todoIndex].todoListId {
            let currentSelection = selection
            let deleteTodo = months[currentSelection].days[index].todos[todoIndex]
            if months[currentSelection].days[index].todos[todoIndex].status == .PROCEED {
                months[currentSelection].days[index].todosCount -= 1
            }
            months[currentSelection].days[index].todos.remove(atOffsets: indexSet)
            container.services.todoService.deleteTodo(todoId: todoId)
                .sink { [weak self] completion in
                    if case .failure(_) = completion {
                        self?.isError = true
                        if deleteTodo.status == .PROCEED {
                            self?.months[currentSelection].days[index].todosCount += 1
                        }
                        self?.months[currentSelection].days[index].todos.append(deleteTodo)
                    }
                } receiveValue: { succeed in
                    
                }.store(in: &subscriptions)
        }
    }
    
    private func deleteTodo(_ todo: Todo) {
        if let index = currentDayIndex,
           let todoIndex = months[selection].days[index].todos.firstIndex(where: { $0.id == todo.id }),
           let todoId = months[selection].days[index].todos[todoIndex].todoListId {
            let currentSelection = selection
            if todo.status == .PROCEED {
                months[currentSelection].days[index].todosCount -= 1
            }
            months[currentSelection].days[index].todos.remove(at: todoIndex)
            
            container.services.todoService.deleteTodo(todoId: todoId)
                .sink { [weak self] completion in
                    if case .failure(_) = completion {
                        self?.isError = true
                        if todo.status == .PROCEED {
                            self?.months[currentSelection].days[index].todosCount += 1
                        }
                        self?.months[currentSelection].days[index].todos.append(todo)
                    }
                } receiveValue: { succeed in
                    
                }.store(in: &subscriptions)
        }
    }
    
    private func createTodo(_ todo: Todo) {
        if let index = currentDayIndex {
            let currentSelection = selection
            months[currentSelection].days[index].todos.append(todo)
            months[currentSelection].days[index].todosCount += 1
            showTextField = false
            container.services.todoService.createTodo(todos: [todo])
                .sink { [weak self] completion in
                    if case .failure(_) = completion {
                        self?.isError = true
                        guard let deleteIndex = self?.months[currentSelection].days[index].todos.firstIndex(where: { $0.id == todo.id} ) else { return }
                        self?.months[currentSelection].days[index].todos.remove(at: deleteIndex)
                        self?.months[currentSelection].days[index].todosCount -= 1
                    }
                } receiveValue: { [weak self] id in
                    guard let self = self else { return }
                    guard let todoIndex = self.months[currentSelection].days[index].todos.firstIndex(where: { $0.id == todo.id }) else { return }
                    self.months[currentSelection].days[index].todos[todoIndex].todoListId = id
                }.store(in: &subscriptions)
        }
    }
    
    private func clickDetailBtn(_ todo: Todo) {
        detailTodo = todo
        isPresent = true
    }
    
    private func updateTodo(_ todo: Todo) {
        guard let currentDayIndex = currentDayIndex else { return }
        container.services.todoService.editTodo(todo: todo)
            .sink { completion in
                
            } receiveValue: { [weak self] succeed in
                guard let self = self else { return }
                self.getTodosCount()
            }.store(in: &subscriptions)
        
        if let todoIndex = months[selection].days[currentDayIndex].todos.firstIndex(where: { $0.id == todo.id }) {
            let oldTodo = months[selection].days[currentDayIndex].todos[todoIndex]
            let components = oldTodo.deadline.split(separator: "-")
            let newMonths = components[0] + "-" + components[1]
            if oldTodo.deadline != todo.deadline {
                months[selection].days[currentDayIndex].todos.remove(at: todoIndex)
                if oldTodo.status == .PROCEED {
                    months[selection].days[currentDayIndex].todosCount -= 1
                }
                if months[selection].selectedDay.format("YYYY-MM") != newMonths {
                    if let newMonthIndex = months.firstIndex(where: { $0.selectedDay.format("YYYY-MM") == newMonths}) {
                        for i in 0..<months[newMonthIndex].days.count {
                            months[newMonthIndex].days[i].request = false
                        }
                    }
                } else {
                    if let newDayIndex = months[selection].days.firstIndex(where: {$0.date.format("YYYY-MM-dd") == todo.deadline}) {
                        months[selection].days[newDayIndex].todos.append(todo)
                        months[selection].days[newDayIndex].todosCount += 1
                    }
                }
                
            } else {
                months[selection].days[currentDayIndex].todos[todoIndex] = todo
            }
        }
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
