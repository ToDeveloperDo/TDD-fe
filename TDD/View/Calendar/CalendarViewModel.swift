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
        let threshold = 3 // 스크롤 시 몇 개월 전에 새 달을 추가할지 결정
        
        // 이전 달 추가
        if selection < threshold {
            if let firstMonth = months.first,
               let newMonth = calendar.date(byAdding: .month, value: -1, to: firstMonth.selectedDay) {
                months.insert(newMonth.createMonth(newMonth), at: 0)
                months.removeLast() // 뒤에서 마지막 달 삭제
                selection += 1 // 추가 후 selection 값을 증가시킴
            }
        }
        
        // 다음 달 추가
        if selection > months.count - threshold - 1 {
            if let lastMonth = months.last,
               let newMonth = calendar.date(byAdding: .month, value: 1, to: lastMonth.selectedDay) {
                months.append(newMonth.createMonth(newMonth))
                months.removeFirst() // 앞에서 첫 번째 달 삭제
                selection -= 1 // 추가 후 selection 값을 감소시킴
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
            if todo.status == .PROCEED {
                months[selection].days[index].todosCount -= 1
            }
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
    
    private func updateTodo(_ todo: Todo) {
        guard let currentDayIndex = currentDayIndex else { return }
        container.services.todoService.editTodo(todo: todo)
            .sink { completion in
                
            } receiveValue: { succeed in
                
            }.store(in: &subscriptions)

        if let todoIndex = months[selection].days[currentDayIndex].todos.firstIndex(where: { $0.id == todo.id }) {
            let oldTodo = months[selection].days[currentDayIndex].todos[todoIndex]
            let components = oldTodo.deadline.split(separator: "-")
            let newMonths = components[0] + components[1] + components[2]
            if oldTodo.deadline != todo.deadline {
                if months[selection].selectedDay.format("YYYY-MM") != newMonths {
                    if let newMonthIndex = months.firstIndex(where: { $0.selectedDay.format("YYYY-MM") == newMonths }) {
                        months[selection].days[currentDayIndex].todos.remove(at: todoIndex)
                        if oldTodo.status == .PROCEED {
                            months[selection].days[currentDayIndex].todosCount -= 1
                        }
                        
                        if let newDayIndex = months[newMonthIndex].days.firstIndex(where: { $0.date.format("YYYY-MM-dd") == todo.deadline}) {
                            months[newMonthIndex].days[newDayIndex].todos.append(todo)
                            if todo.status == .PROCEED {
                                months[newMonthIndex].days[newDayIndex].todosCount += 1
                            }
                        } else {
                            print("해당하는 새로운 날짜를 찾을 수 없음")
                        }
                    } else {
                        print("해당하는 새로운 달을 찾을 수 없음")
                    }
                } else {
                    if let newDayIndex = months[selection].days.firstIndex(where: { $0.date.format("YYYY-MM-dd") == todo.deadline }) {
                        months[selection].days[currentDayIndex].todos.remove(at: todoIndex)
                        if oldTodo.status == .PROCEED {
                            months[selection].days[currentDayIndex].todosCount -= 1
                        }
                        
                        months[selection].days[newDayIndex].todos.append(todo)
                        if todo.status == .PROCEED {
                            months[selection].days[newDayIndex].todosCount += 1
                        }
                    } else {
                        print("해당 하는 새로운 날짜를 찾을 수 없음")
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
