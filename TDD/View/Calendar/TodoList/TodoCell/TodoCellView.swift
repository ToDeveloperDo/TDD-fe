//
//  TodoCellView.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import SwiftUI

struct TodoCellView: View {
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
     var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                switch todo.status {
                case .PROCEED:
                    calendarViewModel.send(action: .clickCheckBox(todo, .proceed))
                case .DONE:
                    calendarViewModel.send(action: .clickCheckBox(todo, .done))
                }
                
            }, label: {
                Image(todo.status == .DONE ? .icSelectedBox : .icUnSelectedBox)
                    .resizable()
                    .frame(width: 18, height: 18)
            })
            
            Text("\(todo.content)")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(.text)
            Spacer()
            Button(action: {
                calendarViewModel.send(action: .clickDetailBtn(todo))
            }, label: {
                Text("더보기")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.textGray)
                    .underline()
            })
        }
        .buttonStyle(.borderless)
    }
}

struct TodoCellView_Previews: PreviewProvider {
    static let container: DIContainer = .init(services: StubService())
    
    static var previews: some View {
        TodoCellView(todo: .stub1)
            .environmentObject(CalendarViewModel(container: container))
    }
}

