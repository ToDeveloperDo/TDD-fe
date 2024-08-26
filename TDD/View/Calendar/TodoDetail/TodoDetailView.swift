//
//  TodoDetailView.swift
//  TDD
//
//  Created by 최안용 on 7/24/24.
//

import SwiftUI

struct TodoDetailView: View {    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CalendarViewModel
    @StateObject var todoDetailViewModel: TodoDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(todoDetailViewModel: todoDetailViewModel)
            TodoInfoView(todoDetailViewModel: todoDetailViewModel)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.serve2)
            todoEditView(todoDetailViewModel: todoDetailViewModel)
                
            Spacer()
        }
        .padding(.vertical, 38)
        .padding(.horizontal, 24)
        .background(Color.fixWh)
        .alert(isPresented: $todoDetailViewModel.isPresent) {
            switch todoDetailViewModel.alert {
            case .edit:
                return Alert(title: Text("수정하시겠습니까?"),
                             primaryButton: .cancel(Text("취소")),
                             secondaryButton: .destructive(Text("확인")) {
                    viewModel.send(action: .updateTodo(todoDetailViewModel.todo))
                    viewModel.isPresent = false
                })
            case .delete:
                return Alert(title: Text("삭제하시겠습니까?"),
                             primaryButton: .cancel(Text("취소")),
                             secondaryButton: .destructive(Text("확인")) {
                    viewModel.send(action: .deleteTodo(todoDetailViewModel.todo))
                    viewModel.isPresent = false
                })
            }
        }
    }
}

private struct HeaderView: View {
    @ObservedObject private var todoDetailViewModel: TodoDetailViewModel
    
    fileprivate init(todoDetailViewModel: TodoDetailViewModel) {
        self.todoDetailViewModel = todoDetailViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            TextField("제목 입력", text: $todoDetailViewModel.todo.content)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.fixBk)
            Spacer()
            HStack(spacing: 12) {
                Button(action: {
                    todoDetailViewModel.isPresent = true
                    todoDetailViewModel.alert = .edit
                }, label: {
                    Image(.editBtn)
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                })
                Button(action: {
                    todoDetailViewModel.isPresent = true
                    todoDetailViewModel.alert = .delete
                }, label: {
                    Image(.deleteBtn)
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                })
            }
        }
        .padding(.bottom, 20)
    }
}

private struct TodoInfoView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject private var todoDetailViewModel: TodoDetailViewModel
    @State private var isEdit: Bool = false
    @FocusState private var isFocused: Bool
    
    fileprivate init(todoDetailViewModel: TodoDetailViewModel) {
        self.todoDetailViewModel = todoDetailViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 16) {
            DatePicker("", selection: $todoDetailViewModel.changeDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .labelsHidden()
                .modifier(TodoInfoModifier(type: .date))
            
            Button(action: {
                switch todoDetailViewModel.todo.status {
                case .PROCEED:
                    viewModel.send(action: .clickCheckBox(todoDetailViewModel.todo, .proceed))
                    todoDetailViewModel.todo.status = .DONE
                case .DONE:
                    viewModel.send(action: .clickCheckBox(todoDetailViewModel.todo, .done))
                    todoDetailViewModel.todo.status = .PROCEED
                }
            }, label: {
                Image(todoDetailViewModel.todo.status == .PROCEED ? .icUnSelectedBox : .icSelectedBox)
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            .modifier(TodoInfoModifier(type: .isDone))
            
            
            Group {
                if todoDetailViewModel.todo.tag.isEmpty || isEdit {
                    TextField("태그", text: $todoDetailViewModel.todo.tag)
                        .focused($isFocused)
                        .onChange(of: isFocused) { oldValue, newValue in
                            if !newValue {
                                isEdit = false
                            } else {
                                isEdit = true
                            }
                        }
                        .padding(.vertical, 3)
                } else {
                    HStack {
                        TagBtn(action: {
                            todoDetailViewModel.todo.tag = ""
                            isFocused = true
                        }, title: todoDetailViewModel.todo.tag)
                        Spacer()
                    }
                }
            }
            .modifier(TodoInfoModifier(type: .tag))
        }
        .padding(.bottom, 28)
    }
}

private struct todoEditView: View {
    @ObservedObject private var todoDetailViewModel: TodoDetailViewModel
    
    fileprivate init(todoDetailViewModel: TodoDetailViewModel) {
        self.todoDetailViewModel = todoDetailViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .top) {
            TextEditor(text: $todoDetailViewModel.todo.memo)
                .font(.system(size: 14, weight: .thin))
                .foregroundStyle(Color.fixBk)
                .scrollContentBackground(.hidden)
                .background(Color.fixWh)
            
            if todoDetailViewModel.todo.memo.isEmpty {
                HStack {
                    Text("설명 입력")
                        .font(.system(size: 14, weight: .thin))
                        .foregroundStyle(Color.serve)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 6)
                .background(Color.fixWh)
                .allowsHitTesting(false)
            }
        }
        .padding(.top, 24)
    }
}

#Preview {
    TodoDetailView(todoDetailViewModel: .init(todo: .stub1, date: Date()))
        .environmentObject(CalendarViewModel(container: .stub))
}
