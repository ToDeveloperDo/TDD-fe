//
//  TodoListView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.todos.isEmpty {
                TodoEmptyView()
            } else {
                TodoListBodyView(viewModel: viewModel)
            }
        }
    }
}

private struct TodoEmptyView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
            Image(.icCalendarBack)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .padding(.bottom, 20)
            Text("이 날에는 일정이 없어요")
                .font(.callout)
                .foregroundStyle(.text)
            Spacer()
        }
    }
}

private struct TodoListBodyView: View {
    @ObservedObject private var viewModel: TodoListViewModel
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    
    fileprivate init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        List {
            if viewModel.todosCount != 0 {
                Section {
                    VStack(alignment: .leading) {
                        Text("진행중")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.text)
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.linegray)
                    }
                    
                    ForEach(viewModel.todos.filter( { $0.status == .PROCEED })) { todo in
                        TodoCellView(todo: todo)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(action: {
                                    calendarViewModel.send(action: .clickCheckBox(todo, .proceed))
                                }, label: {
                                    Image(systemName: "checkmark")
                                })
                                .tint(.green)
                            }
                    }
                    .onDelete(perform: { indexSet in
                        calendarViewModel.send(action: .slideDeleteTodo(indexSet))
                    })
                }
                .listRowSeparator(.hidden)
            }
            
            if viewModel.todos.count - viewModel.todosCount != 0 {
                Section {
                    VStack(alignment: .leading) {
                        Text("완료 ✅")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.text)
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.linegray)
                    }
                    ForEach(viewModel.todos.filter( { $0.status == .DONE })) { todo in
                        TodoCellView(todo: todo)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button(action: {
                                    calendarViewModel.send(action: .clickCheckBox(todo, .done))
                                }, label: {
                                    Image(systemName: "checkmark")
                                })
                                .tint(.green)
                            }
                    }
                    .onDelete(perform: { indexSet in
                        calendarViewModel.send(action: .slideDeleteTodo(indexSet))
                    })
                }
                .listRowSeparator(.hidden)
            }
        }
        .contentMargins(.top, 0)
        .listSectionSpacing(16)
        .listRowBackground(Color.fixWh)
        .background(Color.mainbg)
        .scrollContentBackground(.hidden)
        .animation(.linear, value: viewModel.todos)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        TodoListView(viewModel: .init(todos: [.stub1, .stub2], todosCount: 2))
            .environmentObject(CalendarViewModel(container: Self.container))
    }
}
