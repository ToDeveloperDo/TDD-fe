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
    
    private let screenWidth = UIScreen.main.bounds.width/4
    
    var body: some View {
        VStack {
            HeaderView(todoDetailViewModel: todoDetailViewModel)
            TodoInfoView(todoDetailViewModel: todoDetailViewModel, screenWidth: screenWidth)
            todoEditView(todoDetailViewModel: todoDetailViewModel)
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color.fixWh)
        .alert("수정하시겠습니까?", isPresented: $todoDetailViewModel.isPresent) {
            Button(role: .cancel) {
//                viewModel.send(action: .updateTodo(todo: todoDetailVM.todo))
                dismiss()
            } label: {
                Text("확인")
            }
            Button(role: .destructive) {
                
            } label: {
                Text("취소")
            }
        }
    }
}

private struct HeaderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var todoDetailViewModel: TodoDetailViewModel
    
    fileprivate init(todoDetailViewModel: TodoDetailViewModel) {
        self.todoDetailViewModel = todoDetailViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }, label: {
                Image(.icDownarrow)
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Spacer()
            
            Button(action: {
                todoDetailViewModel.isPresent = true
            }, label: {
                Image(.editBtn)
                    .resizable()
                    .frame(width: 25, height: 25)
                
            })
        }
        .padding(.bottom, 20)
    }
}

private struct TodoInfoView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject private var todoDetailViewModel: TodoDetailViewModel
    @State private var isEdit: Bool = false
    @FocusState private var isFocused: Bool
    
    private var screenWidth: CGFloat
    
    fileprivate init(todoDetailViewModel: TodoDetailViewModel, screenWidth: CGFloat) {
        self.todoDetailViewModel = todoDetailViewModel
        self.screenWidth = screenWidth
    }
    
    fileprivate var body: some View {
        VStack {
            DatePicker("", selection: $todoDetailViewModel.changeDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .labelsHidden()
                .modifier(TodoInfoModifier(type: .date, width: screenWidth))
            
            HStack {
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
                Text("\(todoDetailViewModel.todo.status == .PROCEED ? "진행중" : "완료")")
                    .font(.callout)
                    .foregroundStyle(.text)
                
            }
            .modifier(TodoInfoModifier(type: .isDone, width: screenWidth))
            
            
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
            .padding(.horizontal, 4)
                .modifier(TodoInfoModifier(type: .tag, width: screenWidth))
        }
        .padding(.bottom, 20)
    }
}

private struct todoEditView: View {
    @ObservedObject private var todoDetailViewModel: TodoDetailViewModel
    
    fileprivate init(todoDetailViewModel: TodoDetailViewModel) {
        self.todoDetailViewModel = todoDetailViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            TextField("제목", text: $todoDetailViewModel.todo.content)
                .font(.title2.bold())
            
            TextEditor(text: $todoDetailViewModel.todo.memo)
        }
    }
}

#Preview {
    TodoDetailView(todoDetailViewModel: .init(todo: .stub1, date: Date()))
        .environmentObject(CalendarViewModel(container: .stub))
}
