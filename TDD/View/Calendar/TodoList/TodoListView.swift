//
//  TodoListView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var todoListViewModel: TodoListViewModel
    
     var body: some View {
        VStack(alignment: .leading) {
            if todoListViewModel.todos.isEmpty {
                EmptyView()
            } else {
                TodoListBodyView(todoListViewModel: todoListViewModel)
            }
        }
    }
}

private struct EmptyView: View {
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
    @ObservedObject private var todoListViewModel: TodoListViewModel
    
    fileprivate init(todoListViewModel: TodoListViewModel) {
        self.todoListViewModel = todoListViewModel
    }
    
    fileprivate var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("진행중")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.text)
                    Rectangle().frame(height: 1)
                        .foregroundStyle(.linegray)
                }
                ForEach(todoListViewModel.todos.filter( { $0.status == .PROCEED })) { todo in
                    TodoCellView(todo: todo) {
                        //                        viewModel.send(action: .moveTodo(todo: todo, mode: .finish))
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            //                            viewModel.send(action: .moveTodo(todo: todo, mode: .finish))
                        }, label: {
                            Image(systemName: "checkmark")
                        })
                        .tint(.green)
                    }
                }
                .onDelete(perform: { indexSet in
                    //                    viewModel.send(action: .deleteTodo(index: indexSet))
                })
                
                
            }
            .listRowSeparator(.hidden)
            
            Section {
                VStack(alignment: .leading) {
                    Text("완료 ✅")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.text)
                    Rectangle().frame(height: 1)
                        .foregroundStyle(.linegray)
                }
                ForEach(todoListViewModel.todos.filter( { $0.status == .DONE })) { todo in
                    TodoCellView(isSelected: true, todo: todo) {
                        //                        viewModel.send(action: .moveTodo(todo: todo, mode: .reverse))
                    }
                }
                
            }
            .listRowSeparator(.hidden)
        }
        .contentMargins(.top, 0)
        .listSectionSpacing(16)
        .listRowBackground(Color.fixWh)
        .background(Color.mainbg)
        .scrollContentBackground(.hidden)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        TodoListView(todoListViewModel: .init(todos: [.stub1, .stub2], date: Date(), container: container))
            .environmentObject(Self.container)
    }
}
