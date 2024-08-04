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
    @StateObject var todoDetailVM: TodoDetailViewModel
    
    private let screenWidth = UIScreen.main.bounds.width/4
    
    var body: some View {
        VStack {
            HeaderView(todoDetailVM: todoDetailVM)
            TodoInfoView(todoDetailVM: todoDetailVM, screenWidth: screenWidth)
            todoEditView(todoDetailVM: todoDetailVM)
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .alert("수정하시겠습니까?", isPresented: $todoDetailVM.isPresent) {
            Button(role: .cancel) {
                viewModel.send(action: .updateTodo(todo: todoDetailVM.todo))
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
    @ObservedObject private var todoDetailVM: TodoDetailViewModel
    
    fileprivate init(todoDetailVM: TodoDetailViewModel) {
        self.todoDetailVM = todoDetailVM
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
                todoDetailVM.isPresent = true
            }, label: {
                Image(.icEdit)
                    .resizable()
                    .frame(width: 25, height: 25)
                
            })
        }
        .padding(.bottom, 20)
    }
}

private struct TodoInfoView: View {
    @EnvironmentObject var viewModel: CalendarViewModel
    @ObservedObject private var todoDetailVM: TodoDetailViewModel
    @State private var isEdit: Bool = false
    @FocusState private var isFocused: Bool
    
    private var screenWidth: CGFloat
    
    fileprivate init(todoDetailVM: TodoDetailViewModel, screenWidth: CGFloat) {
        self.todoDetailVM = todoDetailVM
        self.screenWidth = screenWidth
    }
    
    fileprivate var body: some View {
        VStack {
            Button(action: {
                
            }, label: {
                Text("\(todoDetailVM.todo.deadline)")
                    .font(.callout)
                    .foregroundStyle(.blue)
            })            
            .modifier(TodoInfoModifier(type: .date, width: screenWidth))
            
            
            HStack {
                Button(action: {
                    switch todoDetailVM.todo.status {
                    case .PROCEED:
                        todoDetailVM.todo.status = .DONE
                    case .DONE:
                        todoDetailVM.todo.status = .PROCEED
                    }
                }, label: {
                    Image(todoDetailVM.todo.status == .PROCEED ? .icUnSelectedBox : .icSelectedBox)
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                Text("\(todoDetailVM.todo.status == .PROCEED ? "진행중" : "완료")")
                    .font(.callout)
                    .foregroundStyle(.text)
                
            }
            .modifier(TodoInfoModifier(type: .isDone, width: screenWidth))
            
            
            Group {
                if todoDetailVM.todo.tag.isEmpty || isEdit {
                    TextField("태그", text: $todoDetailVM.todo.tag)
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
                        Button(action: {
                            todoDetailVM.todo.tag = ""
                            isFocused = true
                        }, label: {
                            HStack {
                                Image(.icTag)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.fixWh)
                                    .frame(width: 15)
                                Text("\(todoDetailVM.todo.tag)")
                                    .foregroundStyle(.fixWh)
                            }
                            .padding(3)
                            .background(RoundedRectangle(cornerRadius: 5).fill(.green))
                            
                        })
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
    @ObservedObject private var todoDetailVM: TodoDetailViewModel
    
    fileprivate init(todoDetailVM: TodoDetailViewModel) {
        self.todoDetailVM = todoDetailVM
    }
    
    fileprivate var body: some View {
        VStack {
            TextField("제목", text: $todoDetailVM.todo.content)
                .font(.title2.bold())
            
            TextEditor(text: $todoDetailVM.todo.memo)
        }
    }
}

#Preview {
    TodoDetailView(todoDetailVM: .init(todo: .stub1, container: .stub))
        .environmentObject(CalendarViewModel(container: .stub))
}
