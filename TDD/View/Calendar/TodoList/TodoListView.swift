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
            Image(.icCalendarBack)
                .resizable()
                .frame(width: 138, height: 103)
                
            Text("작성된 일정이 없어요")
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(.serve2)
            Spacer()
        }.padding(.top, 91)
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
                            .foregroundStyle(.fixBk)
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.linegray)
                    }
                    .listRowBackground(Color.fixWh)
                    
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
                    .listRowBackground(Color.fixWh)
                }
                .listRowSeparator(.hidden)
            }
            
            if viewModel.todos.count - viewModel.todosCount != 0 {
                Section {
                    VStack(alignment: .leading) {
                        Text("완료 ✅")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.fixBk)
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.linegray)
                    }
                    .listRowBackground(Color.fixWh)
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
                    .listRowBackground(Color.fixWh)
                }
                .listRowSeparator(.hidden)
            }
        }
        .padding(.bottom, 80)
        .contentMargins(.top, 0)
        .listSectionSpacing(16)
        .background(Color.mainbg)
        .scrollContentBackground(.hidden)
        .animation(.linear, value: viewModel.todos)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        TodoListView(viewModel: .init(todos: [], todosCount: 2))
            .environmentObject(CalendarViewModel(container: Self.container))
    }
}
