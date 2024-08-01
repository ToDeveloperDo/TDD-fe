//
//  TodoDetailView.swift
//  TDD
//
//  Created by 최안용 on 7/24/24.
//

import SwiftUI

struct TodoDetailView: View {
    @State var todo: Todo
    @EnvironmentObject var viewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss
    @State var memo: String
    private let screenWidth = UIScreen.main.bounds.width
    
    init(todo: Todo) {
        self.todo = todo
        self.memo = todo.memo
    }
    
    var body: some View {
        VStack {
            headerView
            todoInfoView
            todoEditView
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
    }
    
    private var headerView: some View {
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
                //TODO: 수정 API
            }, label: {
                Image(.icEdit)
                    .resizable()
                    .frame(width: 25, height: 25)
                
            })
        }
        .padding(.bottom, 20)
    }
    
    private var todoInfoView: some View {
        VStack {
            HStack {
                HStack {
                    Label{
                        Text("날짜")
                            .font(.callout)
                            .foregroundStyle(.text)
                    } icon: {
                        Image(.icDetailcalendar)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(.text)
                    }
                    Spacer()
                }.frame(width: screenWidth/4)
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("\(todo.deadline)")
                            .font(.callout)
                            .foregroundStyle(.blue)
                    })
                    Spacer()
                }
            }
            
            HStack {
                HStack {
                    Label{
                        Text("달성")
                            .font(.callout)
                            .foregroundStyle(.text)
                    } icon: {
                        Image(.icCheckBox)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(.text)
                    }
                    Spacer()
                }.frame(width: screenWidth/4)
                
                
                Button(action: {
                    switch todo.status {
                    case .PROCEED:
                        viewModel.send(action: .moveTodo(todo: todo, mode: .finish))
                        todo.status = .DONE
                    case .DONE:
                        viewModel.send(action: .moveTodo(todo: todo, mode: .reverse))
                        todo.status = .PROCEED
                    }
                }, label: {
                    Image(todo.status == .PROCEED ? .icUnSelectedBox : .icSelectedBox)
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                Text("\(todo.status == .PROCEED ? "진행중" : "완료")")
                    .font(.callout)
                    .foregroundStyle(.text)
                
                Spacer()
            }
            
            HStack {
                HStack {
                    Label{
                        Text("태그")
                            .font(.callout)
                            .foregroundStyle(.text)
                    } icon: {
                        Image(.icTag)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(.text)
                    }
                    Spacer()
                }.frame(width: screenWidth/4)
                
                Text("\(todo.tag.isEmpty ? todo.tag : "비어 있음")")
                Spacer()
            }
        }
        .padding(.bottom, 20)
    }
    
    private var todoEditView: some View {
        VStack {
            TextField("제목", text: $todo.content)
                .font(.title2.bold())
            
            TextEditor(text: $memo)
        }
    }
}

#Preview {
    TodoDetailView(todo: .init(content: "코딩하기", memo: "dksjf", tag: "dkfj", deadline: "2024-07-31", status: .DONE))
        .environmentObject(CalendarViewModel(container: .stub))
}
