//
//  TodoInputView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoInputView: View {
    enum Field: Hashable {
        case title, meme
    }
    
    @EnvironmentObject var viewModel: CalendarViewModel
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            TextField("어떤 일을 하시겠습니까?", text: $viewModel.title)
                .focused($focusField, equals: .title)
                .submitLabel(.next)
            
            TextField("설명", text: $viewModel.memo)
                .focused($focusField, equals: .meme)
                .submitLabel(.done)
                .padding(.bottom, 10)
            HStack {
                Label {
                    Text("\(viewModel.selectedDay!.date.format("yyyy년 MM월 dd일 EEEE"))")
                } icon: {
                    Image(.icCalendar)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.red)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.send(action: .createTodo)
                }, label: {
                    Image(.icUparrow)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.fixWh)
                        .padding(1)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(Color.red)
                        )
                })
                .overlay {
                    if viewModel.title == "" {
                        Color.white.opacity(0.5).clipShape(Circle())
                    }
                }
                .disabled(viewModel.title == "" ? true : false)
                
            }            
        }
        .onAppear {
            focusField = .title
        }
        .onSubmit {
            switch focusField {
            case .title:
                focusField = .meme
            case .meme:
                viewModel.showTextField = false
                viewModel.send(action: .createTodo)
            case nil:
                viewModel.showTextField = false
            }
        }
        .onDisappear {
            focusField = nil
            viewModel.title = ""
            viewModel.memo = ""
        }
        .padding(.all, 20)
        .background(Color.fixWh)
        .cornerRadius(10)
    }
}

#Preview {
    TodoInputView()
        .environmentObject(CalendarViewModel(container: .stub))
}
