//
//  TodoListView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @EnvironmentObject var container: DIContainer
    
    
     var body: some View {
        VStack(alignment: .leading) {
            if let selectedDay = viewModel.selectedDay {
                if selectedDay.todos.isEmpty {
                    emptyTodoView
                } else {
                    List {
                        if selectedDay.todosCount != 0 {
                            Section {
                                Text("\(selectedDay.date.format("M월 d일"))")
                                    .font(.caption)
                                    .foregroundStyle(.text)
                                ForEach(selectedDay.todos.filter( { $0.status == .PROCEED })) { todo in
                                    TodoCellView(todo: todo) {
                                        viewModel.send(action: .moveTodo(todo: todo, mode: .finish))
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button(action: {
                                            viewModel.send(action: .moveTodo(todo: todo, mode: .finish))
                                        }, label: {
                                            Image(systemName: "checkmark")
                                        })
                                        .tint(.green)
                                    }
                                }
                                .onDelete(perform: { indexSet in
                                    viewModel.send(action: .deleteTodo(index: indexSet))
                                })
                                
                                
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.fixWh)
                            .listStyle(.plain)
                        }
                        
                        if selectedDay.todos.count - selectedDay.todosCount != 0 {
                            Section {
                                Text("완료")
                                    .font(.caption)
                                    .foregroundStyle(.text)
                                ForEach(selectedDay.todos.filter( { $0.status == .DONE })) { todo in
                                    TodoCellView(isSelected: true, todo: todo) {
                                        viewModel.send(action: .moveTodo(todo: todo, mode: .reverse))
                                    }
                                }
                                
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.fixWh)
                            .listStyle(.plain)
                        }
                    }
                    .animation(.default, value: viewModel.selectedDay?.todos)
                    
                }
            }
        }
        .sheet(isPresented: $viewModel.isPresent) {
            TodoDetailView(todoDetailVM: TodoDetailViewModel(todo: viewModel.detailTodo!, container: container, date: viewModel.selectedDay?.date ?? Date()))
                .presentationDetents([.medium, .large] )
                .presentationDragIndicator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var emptyTodoView: some View {
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

#Preview {
    TodoListView()
        .environmentObject(CalendarViewModel(container: .stub))
}
